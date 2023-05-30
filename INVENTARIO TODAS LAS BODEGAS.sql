SELECT T0."ItemCode", T0."ItemName", T3."ItmsGrpNam", T1."OnHand", T2."WhsCode"
FROM OITM T0  
INNER JOIN OITW T1 ON T0."ItemCode" = T1."ItemCode" 
INNER JOIN OWHS T2 ON T1."WhsCode" = T2."WhsCode" 
INNER JOIN OITB T3 ON T0."ItmsGrpCod"= T3."ItmsGrpCod"
WHERE T1."OnHand" != 0
ORDER BY T1."OnHand" DESC