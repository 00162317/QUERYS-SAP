SELECT T0."ItemCode", T0."ItemName", T0."VATLiable", T1."OnHand", T2."WhsCode", T0."InvntItem" 
FROM OITM T0  
INNER JOIN OITW T1 ON T0."ItemCode" = T1."ItemCode" 
INNER JOIN OWHS T2 ON T1."WhsCode" = T2."WhsCode" 
WHERE T0."VATLiable" = 'N' 
ORDER BY T1."OnHand" DESC