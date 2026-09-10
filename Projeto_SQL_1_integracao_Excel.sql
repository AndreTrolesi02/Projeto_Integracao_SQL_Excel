-- ####################################################
--        PROJETO INTEGRÇÃO SQL SERVER E EXCEL
-- ####################################################

-- Será utilizado o banco de dados AdventureWorksDW2014

-- 1: DEFINIÇÃO DE INDICADORES (KPIs) DO PROJETO

/*
i) Total de vendas pela internet para cada categoria
ii) Receita total de vendas pela internet por mês do pedido
iii) Receita e custo total de vendas pela internet por mês do pedido
iv) Total de vendas pela internet por sexo
*/

-- OBS: O ANO DA ANÁLISE SERÁ APENAS O DE 2013 (ANO DO PEDIDO)

-- 2: DEFINIÇÃO DAS TABELAS A SEREM ANALIZADAS

SELECT * FROM FactInternetSales --Vendas pela internet
SELECT * FROM DimProductCategory --Categorias dos produtos a venda (SERÁ NECESSÁRIO FAZER UM RELACIONAMENTO EM CADEIA)
SELECT * FROM DimSalesTerritory --Territórios de venda
SELECT * FROM DimCustomer --Clientes registrados

--3: DEFININDO A VIEW QUE SERÁ USADA PARA A ANÁLISE (VENDAS_INTERNET)

--COLUNAS:

/*
SalesOrderNumber (FactInternetSales)
OrderDate (FactInternetSales)
EnglishProductCategoryName (DimProductCategory)
FirstName + LastName (DimCustomer)
Gender (DimCustomer)
SalesTerritoryCountry (DimSalesTerritory)
OrderQuantity (FactInternetSales)
TotalProductCost (FactInternetSales)
SalesAmount (FactInternetSales)
*/

--CÓDIGO:

CREATE OR ALTER VIEW VENDAS_INTERNET AS
SELECT 
	SalesOrderNumber AS 'NmrPedido',
	OrderDate AS 'DataPedido',
	EnglishProductCategoryName 'CategoriaProduto',
	FirstName + ' ' + LastName AS 'NomeCliente',
	Gender 'Sexo',
	SalesTerritoryCountry AS 'PaisVenda',
	OrderQuantity AS 'QuantidadePedido',
	TotalProductCost AS 'CustoTotal',
	SalesAmount AS 'ReceitaTotal'
FROM 
	FactInternetSales
INNER JOIN
	DimProduct ON FactInternetSales.ProductKey = DimProduct.ProductKey
		INNER JOIN
			DimProductSubcategory ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
						INNER JOIN
							DimProductCategory ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
INNER JOIN
	DimCustomer ON FactInternetSales.CustomerKey = DimCustomer.CustomerKey
INNER JOIN
	DimSalesTerritory ON FactInternetSales.SalesTerritoryKey = DimSalesTerritory.SalesTerritoryKey
WHERE
	YEAR(OrderDate) = 2013


SELECT * FROM VENDAS_INTERNET