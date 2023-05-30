SELECT T1."ItemCode" Codigo, T3."OnHand" Cantidad_Almacen, T3."AvgPrice" Costo_Unitario, T1."Price" Precio, 
COUNT(T1."ItemCode") HITS, T1."Dscription"
,
CASE 
    WHEN T1."WhsCode" = 'BJP1' THEN 'JUAN PABLO'
    WHEN T1."WhsCode" = 'BME1' THEN 'MERLIOT'
    WHEN T1."WhsCode" = 'SM1' THEN 'SAN MIGUEL'
ELSE T1."WhsCode"
END "SUCURSAL"
FROM OINV T0  

INNER JOIN INV1 T1 ON T0."DocEntry" = T1."DocEntry" 
INNER JOIN OSLP T2 ON T0."SlpCode" = T2."SlpCode"
INNER JOIN OITM T3 ON T1."ItemCode" = T3."ItemCode"
WHERE T0."DocDate" >= [%0] and T0."DocDate" <= [%1]
GROUP BY T1."ItemCode", T3."OnHand", T3."AvgPrice", T1."Price", T1."Dscription", T1."WhsCode"



----


SELECT T1."ItemCode" Codigo,
COUNT(T1."ItemCode") HITS,
CASE 
    WHEN T1."WhsCode" = 'BJP1' THEN 'JUAN PABLO'
    WHEN T1."WhsCode" = 'BME1' THEN 'MERLIOT'
    WHEN T1."WhsCode" = 'SM1' THEN 'SAN MIGUEL'
ELSE T1."WhsCode"
END "SUCURSAL"
FROM INV1 T1  

WHERE T1."DocDate" >= [%0] and T1."DocDate" <= [%1]
GROUP BY T1."ItemCode", T1."Dscription", T1."WhsCode"

--cotizaciones
SELECT T1."ItemCode" Codigo, T1."Dscription",
COUNT(T1."ItemCode") HITS,
CASE 
    WHEN T1."WhsCode" = 'BJP1' THEN 'JUAN PABLO'
    WHEN T1."WhsCode" = 'BME1' THEN 'MERLIOT'
    WHEN T1."WhsCode" = 'SM1' THEN 'SAN MIGUEL'
ELSE T1."WhsCode"
END "SUCURSAL"

FROM QUT1 T1  

WHERE T1."DocDate" >= [%0] and T1."DocDate" <= [%1]
GROUP BY T1."ItemCode", T1."Dscription", T1."WhsCode"