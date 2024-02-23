# 1)List the first name, last name, and full address for all active real estate agents.

select EmployeeFirstName as First_Name, 
EmployeeLastName as Last_Name, 
CONCAT(EmployeeStreet,' ',EmployeeCity,' ',EmployeeState,' ',EmployeeZipCode) as Full_Address
from Employee
where EmployeeType='A' and ActiveYN = 'Y';

# 2)Provide a count of unsold properties by branch (use BranchID). Sort the list by count in descending order.

SELECT BranchID, COUNT(*) AS Unsold_Properties
FROM Property
WHERE SoldYN = 'N'
GROUP BY BranchID
ORDER BY Unsold_Properties DESC;

# 3)List the property ID and full address for all Florida and Georgia properties located on Main Street. Sort the list by state and property ID in ascending order

SELECT PropertyID, Concat(PropertyStreet,' ',PropertyState,' ',PropertyZipCode) as Full_Address
FROM Property
where PropertyState = 'GA' OR PropertyState = 'FL'
AND PropertyStreet like '%Main Street%'
order by PropertyState, PropertyID asc;

# 4)Provide the average listing price for a 2-story property with 3 bedrooms and 2.5 bathrooms.

select avg(ListingPrice) as Average_Listing_Price
from Property
where Stories = 2
and Bedrooms = 3
and Bathrooms = 2.5;

# 5)List the ID, first name, and last name for any customers both are both owners and clients.

select CustomerID, CustomerFirstName, CustomerLastName
from Customer
where OwnerYN = 'Y'
and ClientYN = 'Y';

#  6)Provide a list of real estate agents (use AgentID) who have over 4 million dollars in sales for 2022.

SELECT AgentID, sum(SalePrice) as Sale_Price
FROM Sale
WHERE SaleDate >= '2022-01-01' AND SaleDate <= '2022-12-31'
GROUP BY AgentID 
having sum(SalePrice) > 4000000;

#7)Provide a distinct list of bedrooms and bathrooms for properties less than 1500 square feet. Sort the list by the number of bedrooms and bathrooms.

select distinct Bedrooms, Bathrooms
from Property
where SquareFeet < 1500
order by Bedrooms, Bathrooms;

# 8)Provide the average cost per square foot for properties in California, Michigan, and Texas. Sort the results by cost in descending order. 

select PropertyState, Avg(ListingPrice/SquareFeet) as Cost_Per_Square_Foot 
from Property
where PropertyState in ('CA', 'MI', 'TX')
Group by PropertyState
order by Cost_Per_Square_Foot desc;

#9 Provide a count of unsold properties by branch (use BranchCity). Sort the results by count in descending order

SELECT B.BranchCity, COUNT(*) AS unsold_Property
FROM Branch B
JOIN Property P on B.BranchID = P.BranchID
WHERE P.SoldYN = 'N'
GROUP BY B.BranchCity
ORDER BY unsold_Property DESC;

#10 List the average days on the market (SaleDate - ListingDate) by branch (use BranchCity). Sort the list by average days in ascending order.

SELECT B.BranchCity, AVG(timestampdiff(DAY, P.ListingDate, S.SaleDate)) AS Average_Days_On_Market
FROM Branch B
JOIN Property P ON B.BranchID = P.BranchID
JOIN Sale S ON P.PropertyID = S.PropertyID
GROUP BY B.BranchCity
ORDER BY Average_Days_On_Market ASC;


#11 List the branch ID, agent ID, sales goal, and total sales for active real estate agents who did not meet their sales goal in 2022. Sort the list by branch ID and Employee ID

SELECT e.EmployeeID, b.BranchID, a.AgentID, sum(s.SalePrice) AS TotalSales, SalesGoal FROM Agent a
JOIN Sale s ON a.AgentID = s.AgentID
JOIN Property p ON s.PropertyID = p.PropertyID
JOIN Branch b ON p.BranchID = b.BranchID
JOIN Employee e ON b.BranchID = e.BranchID
WHERE a.SalesGoal < (SELECT SUM(s.SalePrice) FROM Sale s) 
AND e.ActiveYN = 'Y' 
AND YEAR(s.SaleDate) = 2022
GROUP BY e.EmployeeID, b.BranchID, a.AgentID, a.SalesGoal
ORDER BY e.EmployeeID, b.BranchID, a.AgentID;

#12 Provide the full name of property 2000’s owner, along with the full name of their agent.

SELECT concat(C.CustomerFirstName,' ',C.CustomerLastName) AS FullName, 
concat(EmployeeFirstName,' ',E.EmployeeLastName) AS AgentFullName, P.YEARBUILT
FROM Customer C
JOIN Sale S ON C.AgentID = S.AgentID 
JOIN Property P ON S.PropertyID = P.PropertyID
JOIN Employee E ON P.BranchID = E.BranchID
WHERE P.YearBuilt LIKE '200%';

#13 List all active employees (include employee ID, first name, and last name) at branch 14 and their skills if they are paralegals. 

SELECT E.EmployeeID, E.EmployeeFirstName, E.EmployeeLastName, PL.Skills FROM Employee E
JOIN Paralegal PL ON E.EmployeeID = PL.ParalegalID
WHERE BranchID = 14 AND ActiveYN = 'Y';


#14 List the names of the property features that Jennifer Kelly is interested in. Sort the list by feature name is ascending order.

SELECT F.FeatureName FROM Customer C
JOIN ClientFeature CF ON C.CustomerID = CF.ClientID
JOIN Feature F ON CF.FeatureID = F.FeatureID
WHERE CustomerFirstName LIKE 'JENNIFER' AND CustomerLastName LIKE 'KELLY'
ORDER BY F.FeatureName ASC;

#15 Provide the average sale price for a 3 bedroom, 2.5 bathroom property in cities that begin with B. Sort the results by city in ascending order.

SELECT P.PropertyCity, AVG(S.SalePrice) AS AvgSalePrice FROM Sale S 
JOIN Property P ON S.PropertyID =  P.PropertyID
WHERE P.Bedrooms = 3 AND P.Bathrooms = 2.5 AND P.PropertyCity LIKE 'B%'
GROUP BY P.PropertyCity;

#16 List the average percent difference between the listing and sale prices by branch (use BranchCity). Sort the list by percent difference in descending order. (Hint: percent difference = (SalePrice - ListingPrice)/ListingPrice

SELECT B.BranchCity, AVG ((S.SalePrice - P.ListingPrice)/P.ListingPrice) AS AvgPercentDifference FROM Sale S
JOIN Property P ON S.PropertyID = P.PropertyID
JOIN Branch B ON P.BranchID = B.BranchID
GROUP BY B.BranchCity
ORDER BY AvgPercentDifference DESC;