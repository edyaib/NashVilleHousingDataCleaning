---START

select * 

from portfolioproject.dbo.nashvillehousing

---CHANGING DATE AND TIME FORMAT

select  SALEDATE, convert(date,saledate) dadd
from portfolioproject.dbo.nashvillehousing

ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD SALEDATECONVERTED DATE;

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET SALEDATECONVERTED = CONVERT(DATE,SALEDATE)




ALTER TABLE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
ALTER COLUMN SALEDATE DATE 


----- PROPERTY ADRESS DATA

SELECT *
FROM NASHVILLEHOUSING



--WHERE PROPERTYADDRESS IS NULL

ORDER BY ParcelID

SELECT A.[UniqueID ] , A.PARCELID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, B.[UniqueID ], ISNULL(A.PROPERTYADDRESS,B.PropertyAddress)

FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ]<> B.[UniqueID ]
WHERE A.PROPERTYADDRESS IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PROPERTYADDRESS,B.PROPERTYADDRESS)
FROM NASHVILLEHOUSING A
JOIN NASHVILLEHOUSING B
ON A.ParcelID=B.ParcelID
AND A.[UniqueID ]<> B.[UniqueID ]
WHERE A.PROPERTYADDRESS IS NULL

------------------ BREAKING OUT ADRESS INTO INDIVIDUAL COLLUMNS

SELECT PROPERTYADDRESS
FROM NASHVILLEHOUSING

SELECT SUBSTRING(PROPERTYADDRESS,1,CHARINDEX(',',PROPERTYADDRESS)-1) AS ADDRESS1,
SUBSTRING(PROPERTYADDRESS,CHARINDEX(',',PROPERTYADDRESS)+1, LEN(PROPERTYADDRESS)) AS ADDRESS2

FROM NASHVILLEHOUSING


-- STEP 2 CREATE COLUMNS
ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD PropertySplitAddress  nvarchar(255);

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET PropertySplitAddress = SUBSTRING(PROPERTYADDRESS,1,CHARINDEX(',',PROPERTYADDRESS)-1)

ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD PropertySplitCity  nvarchar(255);

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET PropertySplitCity = SUBSTRING(PROPERTYADDRESS,CHARINDEX(',',PROPERTYADDRESS)+1, LEN(PROPERTYADDRESS))



SELECT *

FROM NASHVILLEHOUSING



-------------------------------------------OWNER ADDRESS

SELECT OWNERADDRESS
FROM NASHVILLEHOUSING

Select
parsename(replace(owneraddress,',','.') , 3),
parsename(replace(owneraddress,',','.') , 2),
parsename(replace(owneraddress,',','.') , 1)
FROM NASHVILLEHOUSING

ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD OwnerSplitAddress  nvarchar(255);

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET OwnerSplitAddress = parsename(replace(owneraddress,',','.') , 3)

ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD OwnerSplitCity  nvarchar(255);

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET OwnerSplitCity = parsename(replace(owneraddress,',','.') , 2)

ALTER TABLE PORTFOLIOPROJECT.DBO.nashvillehousing
ADD OwnerSplitState  nvarchar(255);

UPDATE PORTFOLIOPROJECT.DBO.NASHVILLEHOUSING
SET OwnerSplitState = parsename(replace(owneraddress,',','.') , 1)

SELECT OWNERADDRESS, OwnerSplitaddress, OwnerSplitcity, OwnerSplitState
FROM NASHVILLEHOUSING


-----------------------change Y and N to Yes and No in Sold as vacant field

SELECT Distinct(SoldAsVacant), count(soldasvacant)
FROM NASHVILLEHOUSING

group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
case when soldasvacant = 'Y' then 'YES'
     when soldasvacant = 'N' then 'no'
	 else soldasvacant
	 end
	 from nashvillehousing

update NASHVILLEHOUSING
set soldasvacant = case when soldasvacant = 'Y' then 'YES'
     when soldasvacant = 'N' then 'no'
	 else soldasvacant
	 end
	 from nashvillehousing



	 SELECT distinct SoldAsVacant
FROM NASHVILLEHOUSING


----------------------- Remove Duplicates
with rownumCTE as (
select *,row_number () over ( partition by 
         ParcelID,
		 Propertyaddress,
		 Saleprice,
		 saledate,
		 legalreference
		 order by
		 uniqueID) row_num
from NASHVILLEHOUSING
)

select *
from rownumcte

where row_num > 1
order by propertyaddress




select *
from NASHVILLEHOUSING



----------------------------------------------DELETE UNUSED COLUMNS

Select * from NASHVILLEHOUSING


alter table nashvillehousing

drop column owneraddress, taxdistrict, propertyaddress


alter table nashvillehousing
drop column saledate

