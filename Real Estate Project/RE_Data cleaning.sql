use housing;
select * from  nashville ;

-- QUERY 1 : Standarize date format 
select SaleDate, str_to_date(SaleDate, "%M %d, %Y") 
from nashville;

update nashville
set SaleDateConverted = str_to_date(SaleDate, "%M %d, %Y");

--------------------------------------------------------
-- QUERY 2 :Replacing empty values with null values
SELECT NULLIF(PropertyAddress,'') as EmptyStringNULL from nashville;
update nashville
set PropertyAddress = NULLIF(PropertyAddress,'');
 select * from nashville
 where PropertyAddress is null;
----------------------------------------------------------
-- QUERY 3 : Populating the property address using exisiting parcel Id 
 select  a.UniqueID, a.ParcelID, a.PropertyAddress,
		 b.ParcelID, b.PropertyAddress,
        nullif(b.PropertyAddress, a.PropertyAddress) 
 from nashville a
 join nashville b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null;
 update nashville a 
 join nashville b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
set a.PropertyAddress = nullif(b.PropertyAddress, a.PropertyAddress)
 where a.PropertyAddress is null;
 ---------------------------------------------------
-- QUERY 3 : Breaking the property address into individual columns (Adress and City)
 select substring(PropertyAddress, 1, locate(',', PropertyAddress) -1) as address
 , substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress)) as address
 from nashville;

 alter table nashville
 add PropertySplitAddress varchar(225);
 
 update nashville 
 set PropertySplitAddress = substring(PropertyAddress, 1, locate(',', PropertyAddress) -1);
 
  alter table nashville
 add PropertySplitCity varchar(225);
 
 update nashville 
 set PropertySplitCity = substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress));
 select PropertySplitCity from nashville;
 ------------------------------------------------------------
 -- QUERY 4 : Breaking the owner address into individual columns (Adress, City, State)

 select substring_index(OwnerAddress, ',', 1) street
 , substring_index(substring_index(OwnerAddress,',',2), ',',-1) city
 , substring_index(OwnerAddress, ',',-1) state 
 from nashville;
 
 alter table nashville
 add OwnerSplitAddress varchar(225);
 
 update nashville 
 set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1);

 alter table nashville
 add OwnerSplitCity varchar(225);
 
 update nashville 
 set OwnerSplitCity = substring_index(substring_index(OwnerAddress,',',2), ',',-1);
 
  alter table nashville
 add OwnerSplitState varchar(225);
 
 update nashville 
 set OwnerSplitState = substring_index(OwnerAddress, ',',-1);
 ------------------------------------------------
 -- QUERY 5 : Standrize Yes and No
 select distinct(SoldAsVacant), count(SoldAsVacant)
 from nashville
 group by SoldAsVacant
 order by 2;
 -- now we know that Yes and No are used more often, let's change Y and N to Yes and No 
 select SoldAsVacant
 , case when SoldAsVacant = 'No' then 'No'
		when SoldAsVacant = 'Y' then 'Yes' 
        else SoldAsVacant 
        end 
from nashville;

update nashville
set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
		when SoldAsVacant = 'Y' then 'Yes' 
        else SoldAsVacant 
        end ;
-----------------------------------------------------------------
-- QUERY 6 : Removing Duplicates 
with RowNumCTE as(
select * ,
	row_number() over (
    partition by ParcelID,
				PropertyAddress,
                SalePrice, 
                SaleDate,
                LegalReference
                order by UniqueID ) row_num
    from nashville
    -- order by ParcelID;
    ) 
delete from RowNumCTE 
where row_num > 1;

------------------------------------------------------
-- QUERY 7 : Deleting unused columns 
alter table nashville
drop column OwnerAddress ,
drop column PropertyAddress ;