// Consulta 1: Identificar hosts expostos a vulnerabilidades Críticas (CVSS >= 9.0) e respetiva sub-rede
MATCH (h:Host)-[:VULNERAVEL_A]->(v:Vulnerability)
MATCH (h)-[:LOCALIZADO_EM]->(s:Subnet)
WHERE v.cvss >= 9.0
RETURN h.hostname AS Host, h.ip AS IP, s.name AS Subnet, v.cve AS CVE, v.name AS Vulnerabilidade, v.cvss AS Score
ORDER BY v.cvss DESC;

// Consulta 2: Caminho de Movimento Lateral potencial a partir de um host comprometido (ex: SRV-WEB-01)
MATCH path = (origem:Host {id: "SRV-WEB-01"})-[:COMUNICA_COM|TEM_ACESSO*1..3]-(alvo:Host)
WHERE origem <> alvo
RETURN path;

// Consulta 3: Superfície de ataque - Utilizadores sem MFA ativo com acesso direto a servidores
MATCH (u:User {mfa_enabled: false})-[rel:TEM_ACESSO]->(h:Host)
RETURN u.username AS Utilizador, rel.role AS Perfil, h.hostname AS Host_Acedido, h.ip AS IP;
