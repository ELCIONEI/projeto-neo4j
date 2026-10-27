// Restrições de unicidade para garantir integridade e performance
CREATE CONSTRAINT unique_host_id IF NOT EXISTS FOR (h:Host) REQUIRE h.id IS UNIQUE;
CREATE CONSTRAINT unique_user_id IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT unique_vuln_cve IF NOT EXISTS FOR (v:Vulnerability) REQUIRE v.cve IS UNIQUE;
CREATE CONSTRAINT unique_subnet_cidr IF NOT EXISTS FOR (s:Subnet) REQUIRE s.cidr IS UNIQUE;
CREATE CONSTRAINT unique_port_number IF NOT EXISTS FOR (p:Port) REQUIRE p.number IS UNIQUE;
