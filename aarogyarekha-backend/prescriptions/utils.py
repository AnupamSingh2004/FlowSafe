from PIL import Image, ImageEnhance, ImageFilter
import io
import os
from django.conf import settings
from django.core.files.base import ContentFile
import logging

logger = logging.getLogger(__name__)


class ImageProcessor:
    """Handles image compression, enhancement, and OCR processing"""
    
    def __init__(self):
        self.easyocr_reader = None
        # Configure tesseract path if needed
        # pytesseract.pytesseract.tesseract_cmd = r'/usr/bin/tesseract'
    
    def _get_easyocr_reader(self):
        """Lazy load EasyOCR reader"""
        if self.easyocr_reader is None:
            import easyocr
            self.easyocr_reader = easyocr.Reader(['en'])
        return self.easyocr_reader
    
    def compress_image(self, image_file, quality=85, max_width=1200):
        """
        Compress image while maintaining readability for OCR
        """
        try:
            # Open image
            img = Image.open(image_file)
            
            # Convert to RGB if necessary
            if img.mode in ('RGBA', 'LA', 'P'):
                background = Image.new('RGB', img.size, (255, 255, 255))
                background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                img = background
            
            # Resize if too large
            if img.width > max_width:
                ratio = max_width / img.width
                new_height = int(img.height * ratio)
                img = img.resize((max_width, new_height), Image.Resampling.LANCZOS)
            
            # Save compressed image
            output = io.BytesIO()
            img.save(output, format='JPEG', quality=quality, optimize=True)
            output.seek(0)
            
            return ContentFile(output.read())
            
        except Exception as e:
            logger.error(f"Error compressing image: {str(e)}")
            return None
    
    def enhance_image_for_ocr(self, image_file):
        """
        Enhance image for better OCR results
        """
        try:
            import cv2
            import numpy as np
            
            # Open image
            img = Image.open(image_file)
            
            # Convert to grayscale
            if img.mode != 'L':
                img = img.convert('L')
            
            # Enhance contrast
            enhancer = ImageEnhance.Contrast(img)
            img = enhancer.enhance(1.5)
            
            # Enhance sharpness
            enhancer = ImageEnhance.Sharpness(img)
            img = enhancer.enhance(1.2)
            
            # Apply slight blur to reduce noise
            img = img.filter(ImageFilter.MedianFilter(size=3))
            
            # Convert to OpenCV format for advanced processing
            cv_img = cv2.cvtColor(np.array(img), cv2.COLOR_GRAY2BGR)
            
            # Apply adaptive thresholding
            gray = cv2.cvtColor(cv_img, cv2.COLOR_BGR2GRAY)
            thresh = cv2.adaptiveThreshold(
                gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2
            )
            
            # Convert back to PIL
            enhanced_img = Image.fromarray(thresh)
            
            # Save enhanced image
            output = io.BytesIO()
            enhanced_img.save(output, format='JPEG', quality=95)
            output.seek(0)
            
            return ContentFile(output.read())
            
        except Exception as e:
            logger.error(f"Error enhancing image: {str(e)}")
            return None
    
    def extract_text_tesseract(self, image_file):
        """
        Extract text using Tesseract OCR
        """
        try:
            import pytesseract
            
            img = Image.open(image_file)
            
            # Configure tesseract for medical text
            custom_config = r'--oem 3 --psm 6 -c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz.,()/-: '
            
            # Extract text
            text = pytesseract.image_to_string(img, config=custom_config)
            
            # Get confidence scores
            data = pytesseract.image_to_data(img, output_type=pytesseract.Output.DICT)
            confidences = [int(conf) for conf in data['conf'] if int(conf) > 0]
            avg_confidence = sum(confidences) / len(confidences) if confidences else 0
            
            return text.strip(), avg_confidence
            
        except Exception as e:
            logger.error(f"Error with Tesseract OCR: {str(e)}")
            return "", 0.0
    
    def extract_text_easyocr(self, image_file):
        """
        Extract text using EasyOCR
        """
        try:
            import numpy as np
            
            # Read image
            img = Image.open(image_file)
            img_array = np.array(img)
            
            # Perform OCR
            reader = self._get_easyocr_reader()
            results = reader.readtext(img_array)
            
            # Extract text and calculate average confidence
            text_parts = []
            confidences = []
            
            for (bbox, text, confidence) in results:
                if confidence > 0.3:  # Filter low confidence results
                    text_parts.append(text)
                    confidences.append(confidence)
            
            full_text = ' '.join(text_parts)
            avg_confidence = sum(confidences) / len(confidences) if confidences else 0
            
            return full_text.strip(), avg_confidence * 100  # Convert to percentage
            
        except Exception as e:
            logger.error(f"Error with EasyOCR: {str(e)}")
            return "", 0.0
    
    def extract_text_combined(self, image_file):
        """
        Use both Tesseract and EasyOCR, return best result
        """
        try:
            # Try both OCR methods
            tesseract_text, tesseract_conf = self.extract_text_tesseract(image_file)
            easyocr_text, easyocr_conf = self.extract_text_easyocr(image_file)
            
            # Return result with higher confidence
            if tesseract_conf >= easyocr_conf:
                return tesseract_text, tesseract_conf
            else:
                return easyocr_text, easyocr_conf
                
        except Exception as e:
            logger.error(f"Error in combined OCR: {str(e)}")
            return "", 0.0


class MedicineExtractor:
    """Extract medicine information from OCR text"""
    
    def __init__(self):
        # Common medicine name patterns
        self.medicine_keywords = [
            'tab', 'tablet', 'cap', 'capsule', 'syrup', 'injection', 'mg', 'ml',
            'dose', 'dosage', 'twice', 'once', 'thrice', 'daily', 'bd', 'od', 'tds'
        ]
    
    def extract_medicines(self, text):
        """
        Extract medicine information from OCR text
        """
        medicines = []
        lines = text.split('\n')
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
                
            # Check if line contains medicine-related keywords
            if any(keyword.lower() in line.lower() for keyword in self.medicine_keywords):
                medicine_info = self._parse_medicine_line(line)
                if medicine_info:
                    medicines.append(medicine_info)
        
        return medicines
    
    def _parse_medicine_line(self, line):
        """
        Parse individual medicine line
        """
        try:
            parts = line.split()
            
            # Basic extraction - can be improved with NLP
            medicine_info = {
                'name': '',
                'dosage': '',
                'frequency': '',
                'duration': '',
                'instructions': line,
                'extraction_confidence': 0.7  # Basic confidence
            }
            
            # Extract medicine name (usually first part)
            if parts:
                medicine_info['name'] = parts[0]
            
            # Extract dosage (look for mg, ml patterns)
            for part in parts:
                if 'mg' in part.lower() or 'ml' in part.lower():
                    medicine_info['dosage'] = part
                    break
            
            # Extract frequency
            frequency_patterns = ['od', 'bd', 'tds', 'once', 'twice', 'thrice', 'daily']
            for part in parts:
                if part.lower() in frequency_patterns:
                    medicine_info['frequency'] = part
                    break
            
            return medicine_info
            
        except Exception as e:
            logger.error(f"Error parsing medicine line: {str(e)}")
            return None
