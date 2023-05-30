SELECT T0."DocNum", T0."DocStatus", T0."DocDate", T0."Filler", T0."ToWhsCode", T0."JrnlMemo" 
FROM OWTQ T0 WHERE T0."DocDate" >=[%0] and  T0."DocDate" <=[%1]



SELECT T0."DocNum" Numero_Traslado, T0."DocDate", T0."Filler" Desde, T0."ToWhsCode" Hasta, T1."Quantity", T1."ItemCode", T1."Dscription"
FROM OWTQ T0  
INNER JOIN WTQ1 T1 ON T0."DocEntry" = T1."DocEntry" 
WHERE T0."DocDate" >=[%0] AND  T0."DocDate" <=[%1] AND  T0."DocStatus" =[%2]