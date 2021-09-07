select SaleDate,SaleDateConverted from DataCleaning.dbo.NashvilleHousing
------------------------------------------------------------------

--------------------------------Correction the SaleDate data type
-- option 1:Adding new column named SaleDateConverted , then inserting converted value to the new column
alter table nashvillehousing add saleDateConverted date
update NashvilleHousing set SaleDateConverted=CONVERT(date,saledate)

-- option2:Changing the date format directly to SaleDate column
alter table nashvilleHousing alter column saledate  date

-------------------------------------------------------------------

---------------------------------Populate the property address
select * from NashvilleHousing where PropertyAddress is null-------------checking for null values


-- for same parcelid, it is considered to be of same address
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress from
NashvilleHousing a join NashvilleHousing b 
on a.ParcelID= b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


---adding the values to the null positions
update a
set PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from
NashvilleHousing a join NashvilleHousing b 
on a.ParcelID= b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

------------------------------------------------------------------------------------------------
-----------------------------------------Breaking Out Address Into individual columns (Address, City ,State)

select 
SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as city
from NashvilleHousing

alter table nashvillehousing
add propertySplitAddress nvarchar(225);

update  nashvillehousing
set propertySplitAddress= SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1);

alter table nashvillehousing
add propertySplitCity nvarchar(225);

update  nashvillehousing
set propertySplitCity= substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select * from NashvilleHousing

-------------------working with ownerAddress
select OwnerAddress
from NashvilleHousing

select
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing add OwnerSplitAddress nvarchar(225)

update NashvilleHousing
set ownersplitaddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table NashvilleHousing add OwnerSplitCity nvarchar(225)

update NashvilleHousing
set ownersplitcity=PARSENAME(replace(OwnerAddress,',','.'),2)

alter table NashvilleHousing add OwnerSplitState nvarchar(225)

update NashvilleHousing
set ownersplitState=PARSENAME(replace(OwnerAddress,',','.'),1)


----------------------------------------------------------------------------------
---------------------Replace Yes, No with Y,N
select * from DataCleaning.dbo.NashvilleHousing

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from DataCleaning.dbo.NashvilleHousing group by soldasvacant

Update  DataCleaning.dbo.NashvilleHousing
set soldasvacant=case when soldasvacant='Y' then 'Yes'
when soldasvacant='N' then 'No'
else soldasvacant
end

------------------------------------------------------------------------------------
---------------------Cleaning duplicates

with rownumcte as(
select *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,PROPERTYADDRESS,SALEPRICE,SALEDATE,LEGALREFERENCE
	   ORDER BY UNIQUEID)row_num
from  DataCleaning.dbo.NashvilleHousing)
select * from rownumcte
where row_num>1
order by PropertyAddress
---------------------------
with rownumcte as(
select *,
       ROW_NUMBER() OVER(
	   PARTITION BY ParcelID,PROPERTYADDRESS,SALEPRICE,SALEDATE,LEGALREFERENCE
	   ORDER BY UNIQUEID)row_num
from  DataCleaning.dbo.NashvilleHousing)
DELETE from rownumcte
where row_num>1

--------------------------------------------------------------------------------------
-------------------------------DELETING UNUSED COLUMNS

alter table DataCleaning.dbo.NashvilleHousing
drop column owneraddress,taxdistrict,propertyaddress,saledate

select * from DataCleaning.dbo.NashvilleHousing
