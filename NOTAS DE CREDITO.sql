SELECT T0."DocNum", T3."SeriesName", 
CASE 
    WHEN T0."DocStatus" = 'C' THEN 'CLOSE'
    WHEN T0."DocStatus" = 'O' THEN 'OPEN'
ELSE T0."DocStatus"
END "Estado",T0."DocDate", T0."DocDueDate",  T0."CardCode", T0."CardName", T1."SlpName", 
T1."Memo" as "Sucursal Vendedor", T2."PymntGroup", T0."DocTotal" 
FROM ORIN T0  INNER JOIN OSLP T1 ON T0."SlpCode" = T1."SlpCode" 
INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum" 
INNER JOIN NNM1 T3 ON T0."Series" = T3."Series"
WHERe T0."DocDate">= [%0] AND  T0."DocDate"<= [%1]


------
SELECT T0."DocNum", T3."SeriesName", 
CASE 
    WHEN T0."DocStatus" = 'C' THEN 'CLOSE'
    WHEN T0."DocStatus" = 'O' THEN 'OPEN'
ELSE T0."DocStatus"
END "Estado",T0."DocDate", T0."DocDueDate",  T0."CardCode", T0."CardName", T1."SlpName", 
T1."Memo" as "Sucursal Vendedor", T2."PymntGroup", T0."DocTotal" 
FROM ORIN T0  INNER JOIN OSLP T1 ON T0."SlpCode" = T1."SlpCode" 
INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum" 
INNER JOIN NNM1 T3 ON T0."Series" = T3."Series"
WHERe T0."DocDate">= [%0] AND  T0."DocDate"<= [%1]