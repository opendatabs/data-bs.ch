# Get the source data for ODS dataset 100057 "OGD Datensätze"
# 55 * * * *
curl --user user:password --output /home/opendata/public_html/opendatasoft/datasets/public_ods_datasets.csv --silent "https://data.bs.ch/explore/dataset/100055/download/?format=csv&use_labels_for_header=true&refine.visibility=domain&refine.publishing_published=True"