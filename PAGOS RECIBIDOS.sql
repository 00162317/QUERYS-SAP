SELECT T0."DocNum", T0."DocDate", T0."CardCode", T0."CardName", T0."DocTotal" 
FROM ORCT T0 
WHERE T0."DocDate" >=[%0] AND  T0."DocDate" <=[%1] 
AND T0."CardCode" LIKE '%C%' AND T0."CardCode" != 'C00667' AND T0."CardCode" != 'C00668' 
AND T0."CardCode" != 'C00669' AND T0."CardCode" != 'C03975' and T0."Canceled" != 'Y'