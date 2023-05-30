SELECT T0."CardCode", T0."CardName", T0."LicTradNum" as "Nit", T0."U_DUI", T0."Cellular",T0."Phone1", T0."Phone2", T0."AddID" as "Nrc", T0."E_Mail", T4."SlpName" as "Vendedor", T2."PymntGroup" "Condicion de Pago", T3."GroupName" "Categoria" , T1."ListName", T0."Notes", T0."CreditLine", T0."DebtLine"
, T0."AliasName" "Giro de Negocio", T0."U_CXC1", T0."U_CXC2", T0."Balance", T8."TaxCode" FROM OCRD T0  
INNER JOIN CRD1 T8 ON T0."CardCode" = T8."CardCode"
INNER JOIN OPLN T1 ON T0."ListNum" = T1."ListNum" 
INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum" 
INNER JOIN OCRG T3 ON T0."GroupCode" = T3."GroupCode"
INNER JOIN OSLP T4 ON T0."SlpCode" = T4."SlpCode"
 WHERE T0."CardType" ='C'
ORDER BY T0."U_DUI" DESC