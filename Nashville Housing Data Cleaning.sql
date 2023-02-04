SELECT *
FROM PortfolioProject..NashvilleHousing

--changing date format

SELECT SaleDataConverted, CONVERT(date,SaleDate)
FROM PortfolioProject..NashvilleHousing 

UPDATE NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDataConverted Date;

UPDATE NashvilleHousing
SET SaleDataConverted = CONVERT(date,SaleDate)

-- populate adress data

SELECT *
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and  a.[UniqueID ] <> b.[UniqueID ]
--WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and  a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-- address to adress, city, state

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress)) AS Address
FROM PortfolioProject..NashvilleHousing	

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(propertyaddress))

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing	

SELECT
PARSENAME(REPLACE(owneraddress, ',', '.'), 3)
, PARSENAME(REPLACE(owneraddress, ',', '.'), 2)
, PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
FROM PortfolioProject..NashvilleHousing	

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);
UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)

SELECT *
FROM PortfolioProject..NashvilleHousing	

--changing yes/no to y/n

SELECT distinct(SoldAsVacant), COUNT(soldasvacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
	   when SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

SELECT distinct(SoldAsVacant), COUNT(soldasvacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- remove duplicates

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY parcelID,
				 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 ORDER BY uniqueID
				 ) row_num
FROM PortfolioProject..NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM PortfolioProject..NashvilleHousing

-- deleting column

SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE portfolioproject..nashvillehousing
DROP COLUMN owneraddress, taxdistrict, propertyaddress, Saledate

SELECT *
FROM PortfolioProject..NashvilleHousing