
-- Cleaning Data in SQL Queries

Select *
From PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------

-- Standardize Date format

Select Saledate, Convert(date, Saledate)
From PortfolioProject..NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate = Convert(date, Saledate)

Alter Table Portfolioproject..NashvilleHousing
Add SaleDate2 Date;

Update PortfolioProject.dbo.NashvilleHousing
Set SaleDate2 = Convert(date, Saledate)

Select SaleDate2
From PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-----------------------------------------------------------------------------------------

-- Breaking out Address into Individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject..NashvilleHousing

-- Getting rid of the comma (,)

Select 
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress) ) as City
From PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From PortfolioProject..NashvilleHousing

-- Owner Address 

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From PortfolioProject..NashvilleHousing

-----------------------------------------------------------------------------------------

-- Change Y and N to YEs and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE 
	WHEN SoldAsVacant = 'Y' then 'Yes'
	WHEN SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE 
	WHEN SoldAsVacant = 'Y' then 'Yes'
	WHEN SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END

-----------------------------------------------------------------------------------------

-- Remove Duplicates
-- Not Standard Practice to delete data from DB (only for the sake of this Project)

With RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
-- order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1
Order By PropertyAddress

/*
DELETE 
From RowNumCTE
where row_num > 1
Order By PropertyAddress
*/
-----------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

