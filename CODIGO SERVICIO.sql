SELECT T2."DocNum", T2."CardCode", T2."CardName", T2."DocStatus", T2."DocDate", T3."ItemCode", 
T3."Dscription", T3."LineTotal" 
FROM "10028_COPPER_ES"."OINV" T2 
INNER JOIN INV1 T3 ON T3."DocEntry" = T2."DocEntry"
WHERE T2."DocDate" >=[%0] and  T2."DocDate" <=[%1] AND T2."isIns" = 'Y' and T3."ItemCode" = 'SERVICIO'
OR T3."ItemCode" = 'SERVICIO 1' OR T3."ItemCode" = 'SERVICIO 2' OR T3."ItemCode" = 'SERVICIO 3' OR T3."ItemCode" = 'SERVICIO 4'