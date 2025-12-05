from PIL import Image, ImageChops

def crop_black_border(image_path):
    img = Image.open(image_path)
    bg = Image.new(img.mode, img.size, (0, 0, 0)) # Create black background
    diff = ImageChops.difference(img, bg)
    diff = ImageChops.add(diff, diff, 2.0, -100)
    bbox = diff.getbbox()
    if bbox:
        return img.crop(bbox)
    return img

try:
    input_path = 'frontend/assets/govbuddy_logo.png'
    cropped_img = crop_black_border(input_path)
    cropped_img.save(input_path)
    print(f"Successfully cropped {input_path}")
except Exception as e:
    print(f"Error processing image: {e}")
