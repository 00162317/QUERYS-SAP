SELECT T0."ItemCode", T0."ItemName",T1."IsCommited" Comprometido,T2."WhsCode" 
FROM OITM T0  
INNER JOIN OITW T1 ON T0."ItemCode" = T1."ItemCode" 
INNER JOIN OWHS T2 ON T1."WhsCode" = T2."WhsCode" 
WHERE T1."IsCommited"!=0
ORDER BY T1."IsCommited" DESC
