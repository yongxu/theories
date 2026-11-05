"""Query Europe PMC: print pmcid, year, title for a query. No file kept."""
import sys, json, urllib.parse, urllib.request
q = sys.argv[1]
n = sys.argv[2] if len(sys.argv) > 2 else "8"
u = "https://www.ebi.ac.uk/europepmc/webservices/rest/search?format=json&pageSize=%s&query=%s" % (n, urllib.parse.quote(q))
with urllib.request.urlopen(u, timeout=60) as r:
    d = json.load(r)
print(d.get("hitCount"))
for x in d.get("resultList", {}).get("result", []):
    print(x.get("pmcid"), x.get("pubYear"), x.get("authorString", "")[:60], "|", x.get("title", "")[:110], "|", x.get("journalTitle",""), "| OA", x.get("isOpenAccess"), "| doi", x.get("doi"))
