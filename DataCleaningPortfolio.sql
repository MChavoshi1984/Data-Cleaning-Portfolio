/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------

--Standardize Data Format

SELECT SaleDateconverted,Convert(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD SaleDateconverted Date;

Update NashvilleHousing
SET SaleDateconverted=CONVERT(Date,SaleDate)

---------------------------------------------------------------------------------------------------------------------

--Populate Property Address Data

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
ORDER BY ParcelID


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null


 UPDATE a
 SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null




 --------------------------------------------------------------------------------------------------------------------

 --Breaking Out Address into Indivitual Columns(Address,City,State)

 SELECT 
 SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
 ,SUBSTRING(Propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing

  ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255) ;

Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(Propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

 ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255) ;

Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(Propertyaddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


SELECT 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing


  ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255) ;

Update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

 ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255) ;

Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255) ;

Update NashvilleHousing
SET OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
,Case when SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END
From PortfolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
Set SoldAsVacant=Case when SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  ELSE SoldAsVacant
	  END


--------------------------------------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE as(
SELECT *,
        ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
		             PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY
					 UniqueID
					 ) row_num

FROM PortfolioProject.dbo.NashvilleHousing
)
--DELETE
--FROM RowNumCTE
--WHERE row_num>1
--ORDER BY PropertyAddress

select *
FROM RowNumCTE
WHERE row_num>1
order by PropertyAddress


--------------------------------------------------------------------------------------------------------------------------------------------------

--DELETE Unused Columns


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

