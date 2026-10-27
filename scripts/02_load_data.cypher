// Criação das Sub-redes
CREATE (s_corp:Subnet {name: "Corporativa", cidr: "192.168.1.0/24"})
CREATE (s_dmz:Subnet {name: "DMZ Externa", cidr: "10.0.1.0/24"})
CREATE (s_db:Subnet {name: "Zona de Dados Restrita", cidr: "172.16.0.0/24"});

// Criação dos Hosts
CREATE (srv_web:Host {id: "SRV-WEB-01", hostname: "webserver.prod", ip: "10.0.1.10", os: "Linux Ubuntu 20.04"})
CREATE (srv_db:Host {id: "SRV-DB-01", hostname: "database.prod", ip: "172.16.0.50", os: "PostgreSQL Linux"})
CREATE (ws_dev:Host {id: "WS-DEV-03", hostname: "dev-laptop.corp", ip: "192.168.1.15", os: "Windows 11"})
CREATE (srv_ad:Host {id: "SRV-DC-01", hostname: "activedirectory.corp", ip: "192.168.1.2", os: "Windows Server 2022"});

// Associação com as Sub-redes
MATCH (srv_web:Host {id: "SRV-WEB-01"}), (s_dmz:Subnet {cidr: "10.0.1.0/24"})
CREATE (srv_web)-[:LOCALIZADO_EM]->(s_dmz);

MATCH (srv_db:Host {id: "SRV-DB-01"}), (s_db:Subnet {cidr: "172.16.0.0/24"})
CREATE (srv_db)-[:LOCALIZADO_EM]->(s_db);

MATCH (ws_dev:Host {id: "WS-DEV-03"}), (srv_ad:Host {id: "SRV-DC-01"}), (s_corp:Subnet {cidr: "192.168.1.0/24"})
CREATE (ws_dev)-[:LOCALIZADO_EM]->(s_corp), (srv_ad)-[:LOCALIZADO_EM]->(s_corp);

// Portos de rede
CREATE (p80:Port {number: 80, service: "HTTP"})
CREATE (p443:Port {number: 443, service: "HTTPS"})
CREATE (p22:Port {number: 22, service: "SSH"})
CREATE (p3389:Port {number: 3389, service: "RDP"})
CREATE (p5432:Port {number: 5432, service: "PostgreSQL"});

MATCH (srv_web:Host {id: "SRV-WEB-01"}), (p80:Port {number: 80}), (p443:Port {number: 443}), (p22:Port {number: 22})
CREATE (srv_web)-[:ABRE]->(p80), (srv_web)-[:ABRE]->(p443), (srv_web)-[:ABRE]->(p22);

MATCH (srv_db:Host {id: "SRV-DB-01"}), (p5432:Port {number: 5432})
CREATE (srv_db)-[:ABRE]->(p5432);

MATCH (srv_ad:Host {id: "SRV-DC-01"}), (p3389:Port {number: 3389})
CREATE (srv_ad)-[:ABRE]->(p3389);

// Vulnerabilidades
CREATE (cve1:Vulnerability {cve: "CVE-2021-44228", name: "Log4Shell", cvss: 10.0, severity: "Critical"})
CREATE (cve2:Vulnerability {cve: "CVE-2023-38606", name: "Kernel Privilege Escalation", cvss: 7.8, severity: "High"})
CREATE (cve3:Vulnerability {cve: "CVE-2024-21413", name: "Microsoft Outlook RCE", cvss: 9.8, severity: "Critical"});

MATCH (srv_web:Host {id: "SRV-WEB-01"}), (cve1:Vulnerability {cve: "CVE-2021-44228"})
CREATE (srv_web)-[:VULNERAVEL_A]->(cve1);

MATCH (ws_dev:Host {id: "WS-DEV-03"}), (cve3:Vulnerability {cve: "CVE-2024-21413"})
CREATE (ws_dev)-[:VULNERAVEL_A]->(cve3);

// Utilizadores e Credenciais
CREATE (u_admin:User {id: "USR-001", username: "admin_sec", mfa_enabled: true})
CREATE (u_dev:User {id: "USR-042", username: "lucas_dev", mfa_enabled: false})
CREATE (u_svc:User {id: "SVC-APP", username: "svc_web_db", mfa_enabled: false});

MATCH (u_admin:User {id: "USR-001"}), (srv_ad:Host {id: "SRV-DC-01"})
CREATE (u_admin)-[:TEM_ACESSO {role: "Domain Admin"}]->(srv_ad);

MATCH (u_dev:User {id: "USR-042"}), (ws_dev:Host {id: "WS-DEV-03"})
CREATE (u_dev)-[:TEM_ACESSO {role: "Local User"}]->(ws_dev);

MATCH (u_svc:User {id: "SVC-APP"}), (srv_web:Host {id: "SRV-WEB-01"}), (srv_db:Host {id: "SRV-DB-01"})
CREATE (u_svc)-[:TEM_ACESSO {role: "Application Service"}]->(srv_web),
       (u_svc)-[:TEM_ACESSO {role: "DB ReadWrite"}]->(srv_db);

// Fluxo de Tráfego / Conexões Ativas
MATCH (srv_web:Host {id: "SRV-WEB-01"}), (srv_db:Host {id: "SRV-DB-01"})
CREATE (srv_web)-[:COMUNICA_COM {protocol: "TCP", port: 5432}]->(srv_db);

MATCH (ws_dev:Host {id: "WS-DEV-03"}), (srv_ad:Host {id: "SRV-DC-01"})
CREATE (ws_dev)-[:COMUNICA_COM {protocol: "TCP", port: 3389}]->(srv_ad);
