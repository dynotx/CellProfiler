
from cellprofiler.library.functions.image_processing import morphology_opening

def opening(image, structuring_element, planewise):
    return morphology_opening(
        image,
        structuring_element,
        planewise
    )