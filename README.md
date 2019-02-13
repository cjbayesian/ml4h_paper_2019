# ML4H 2018 NeurIPS paper analysis

## Pipeline:

1. Get the metadata for all papers `NeurIPS_Proceedings_Metadata.ipynb`
2. Download the pdfs `NeurIPS_Proceedings_dl_pdfs.ipynb`
3. Extract raw text from pdfs `NeurIPS_Proceedings_pdf2text.ipynb`
4. Run text pre-processing `NeurIPS_Proceedings_preprocess.ipynb`

## Requires

### Python
- Python >= 3.7
- requests
- beautifulsoup4
- pandas
- json

### Other
- pdftotext version 0.64.0
