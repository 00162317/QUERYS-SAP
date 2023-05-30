SELECT T0."CardCode",T0."CardName", T0."LicTradNum" as "Nit", T0."AddID" as "Nrc", T2."PymntGroup" "Condicion de Pago", 
    T0."CreditLine",T3."GroupName" "Categoria" , T1."ListName"
    , T0."AliasName" "Giro de Negocio", T0."U_CXC2" 
FROM OCRD T0  
    INNER JOIN OPLN T1 ON T0."ListNum" = T1."ListNum" 
    INNER JOIN OCTG T2 ON T0."GroupNum" = T2."GroupNum" 
    INNER JOIN OCRG T3 ON T0."GroupCode" = T3."GroupCode"

WHERE T2."PymntGroup" = 'Credito 30 Dias' or T2."PymntGroup" = 'Credito 15 Dias' or
      T2."PymntGroup" = 'Credito 90 Dias' or T2."PymntGroup" = 'Credito 60 Dias'

ORDER BY T0."CreditLine" DESC