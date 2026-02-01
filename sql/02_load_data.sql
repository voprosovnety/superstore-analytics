-- data loading and basic cleaning steps
-- the dataset is loaded into raw_superstore table using the following command:
-- executed in psql (client), not on the server:
-- replace '/path/to/project' with the absolute path to your project directory

-- \copy raw_superstore
--     from '/path/to/project/data/raw/sample_superstore.csv'
--     with (format csv, header true, delimiter ',', encoding 'LATIN1');

-- optional cleaning transformations can be added here if needed