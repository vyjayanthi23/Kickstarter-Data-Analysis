# Data Cleaning Documentation

## Source File
Kickstarter (2017), Kickstarter Projects (3) [Data file]. Retrieved September 10, 2018, from https://www.kaggle.com/kemical/kickstarter-projects

The source file for our Kickstarter Data Analysis was taken from kaggle.com, under a Creative Commons BY-NC-SA 4.0 license. This means that, as long as we provide the appropriate attribution, do not use the data for commercial purposes, and share our work under the same license, we are free to share and adapt the dataset.

The file contains the following columns:
1. ID - unique 10 digit number for the project
2. Name - Alphanumeric name, or title, of the project
3. Category - Sub-category within the main category, defining the type of project within the main category
4. Main Category - Category of project
5. Currency - Three letter designation of the currency the kickstarter used in presenting its goals
6. Deadline - Datetime when the project anticipated being funded by
7. Goal - Total number amount of specified currency at which the project would be considered complete
8. Launched - Datetime when the project launched
9. Pledged - The amount pledged to the Kickstarter in the currency specified
10. State - Final outcome of the kickstarter, as represented by the values "successful", "failed", or "cancelled"
11. Backers - Number of individuals contributing funds to the project
12. Country - Country of origin of the Kickstarter
13. USD Pledged - Pledged column converted to a dollar amount

## Metadata
> 1 paragraph description of the metadata: what information is available to help you
interpret and understand the data?

## Issues with the data
> Identify any issues you have encountered with the data: missing values, unstandardized content, entity matching, etc.

Technically, there did not appear to be too many issues with the data.  However, both files required editing in order to make them usable for the purposes of analysis in R.  In addition, since the dataset included various currencies over a span of multiple years (during which conversion rates would have fluctuated greatly), and because we are making our recommendations about launching a successful Kickstarter campaign to a US-based audience, we decided to focus only on records where the currency used was USD.  

## Cleaning the file
The following operations were performed on the files.

### Lowercasing the "ID" column
In the source file, the "ID" column appears first in the file and is presented in upper case. This causes an error when attempting to open the file in Excel, which claims that the file is not in a valid format. 

In order to make the file more user-friendly, both files were edited via text editor to format the "ID" column as "id". 

### Combining the files
To create a single complete dataset, values from ks-projects-201801.csv were added to ks-projects-201612.csv. This resulted in the omission of the USD_Pledged_Real and USD_Goal_Real in order to create a uniform dataset.

### Removing non-ASCII characters from name
Many Kickstarters contain characters that do not map correctly to most US charsets, such as the Germanic o with an umlaut or accented characters in Spanish. Due to low value of this column and the high likelihood of charset-related errors on import, characters not in the ASCII standard were removed from the Name column. Values were not replaced. This results in some missing letters in certain names, but overally readability is not compromised as the surrounding characters are preserved. 

### USD_Pledged from Float to Int
Certain Kickstarters appear to have solicited partial dollar amounts from backers, resulting in some rows existing as floats rather than as ints. Due to the low incidence of floats and the low value of the partial data, floats were truncated to ints in the final file. 

### Launched - Removed values from the year 1970
Some values appear to have defaulted to 1/1/1970. This is definitely incorrect, and these dates have been removed from the column. 

### Removed non-USD values
We were a little uncertain how the dataset was representing foreign currencies and their comprable USD values. These values may have been calculated at the time, or after the fact, or someone may have invented them entirely. Rather than relying on the data provided and assuming a rule had been uniformly applied to all currency types, we chose to limit our analysis to Kickstarters that used USD as their currency. 

### Removed Duplicates
Some rows appeared twice, either due to inclusion in both files or some error in data preparation. These rows were removed. 
