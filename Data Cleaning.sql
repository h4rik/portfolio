/*
Cleaning data in SQL Queries
*/


select * 
from [Portfolio Project].dbo.NashvilleHousing


--To make data format correct

select saleDateConverted,CONVERT(Date,SaleDate)
from [Portfolio Project].dbo.NashvilleHousing

update [Portfolio Project].dbo.NashvilleHousing
SET SaleDate = CONVERT(date,SaleDate) 

ALTER Table [Portfolio Project].dbo.NashvilleHousing
Add saleDateConverted Date;

update [Portfolio Project].dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate) 



--Populate Property Address data

select *
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND  a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL 



update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND  a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL 



--Dividing Address into individual columns(Address , City , State)

select *
from [Portfolio Project].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select
SUBSTRING(PropertyAddress , 1 ,CHARINDEX(',' , PropertyAddress) -1 ) As Address , 
SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress)) As Address 
from [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project].dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress , 1 ,CHARINDEX(',' , PropertyAddress) -1 );

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio Project].dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress)) ;

select * 
from [Portfolio Project].dbo.NashvilleHousing



--Dividing owner address


select OwnerAddress
from [Portfolio Project].dbo.NashvilleHousing


Select 
PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 3)
,PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 2)
,PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 1) 
from [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 3)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 2)

ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portfolio Project].dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress , ',' , '.') , 1) 


select * 
from [Portfolio Project].dbo.NashvilleHousing



--Change Y and N to Yes and No

Select Distinct(SoldAsVacant) , count(SoldAsVacant)
from [Portfolio Project].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2 


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
       END
from [Portfolio Project].dbo.NashvilleHousing


update [Portfolio Project].dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
       END





--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num 
from [Portfolio Project].dbo.NashvilleHousing
--Order by ParcelID
) 
Select * 
from RowNumCTE
where row_num > 1
Order By PropertyAddress


Select * 
from [Portfolio Project].dbo.NashvilleHousing



--Delete Unused coulumns


ALTER Table [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN  OwnerAddress , TaxDistrict , PropertyAddress


ALTER Table [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN  SaleDate

Select * 
from [Portfolio Project].dbo.NashvilleHousing
