# The field's published estimates for the stocks T2's tests read

UE32, 3 November 2026. AI-written (a Claude Code session; no person's review of it is recorded). For each stock that T2's three frozen fish-stock tests read, the field's own published estimate of how many delays forecast its series best, where one was found. About ten minutes to read.

**What T2's tests read.** MQ4 and MQ5 fitted 277 stocks of the RAM Legacy Stock Assessment Database v4.66 between them, none in both ([MQ4's](../margin-measured/results/mq4/VERDICTS-mq4.json) 76 primary, 11 control and 92 other; [MQ5's](../margin-measured/results/mq5/VERDICTS-mq5.json) 69, 5 and 24). MQ7's stocks, from ICES and NOAA Stock SMART (21 in its primary group; its verdict drew on 5), are not counted here; an independent reader of these documents found none of MQ7's 21 primary stocks, as its predictions list them, among Pierre's 53. The level each test read matters below: MQ4 read total biomass (`TB-MT` in its fits), MQ5 spawning biomass.

**What the field publishes per stock.** Of the studies read ([FIELD-READING.md](FIELD-READING.md)), one gives a per-stock table that was seen: Pierre, Rouyer, Bonhommeau and Fromentin (2018, ICES Journal of Marine Science 75:903–911, Supplementary Appendix 1). It gives, for 53 stocks with at least 40 consecutive years, the embedding dimension E that simplex projection chose for recruitment (E_R) and for the spawning stock (E_SSB), with τ = 1, E tried from 2 to a quarter of the series' length, the first half of the embedded vectors as the library and the second half predicted. Its series came from RAM Legacy (an earlier release than v4.66) and from an ICES and NAFO compilation. Its per-stock S-map θ, the field's measure of nonlinearity, was **not seen**: its Figure 4a says most recruitment series had θ > 0. Storch et al. (2017)'s text points to a per-stock S2 Table, and Munch et al. (2018) and Hechler and Krkosek (2025) may hold per-stock values; none was **seen**. Glaser et al. (2014), whose per-series results could not be reached, was read only through its abstract and papers that cite it.

**How the stocks were matched.** By species and area, from Pierre's stock names to the RAM ids T2's tests read. RAM's stock table, which gives each id its long name, is not on this machine (MQ3 to MQ5 read it from the archive extracted outside the repository, since removed), so each id was read from its code. *Same*: the code names the same species and area. *Same, renamed*: the area under a later name. *Probable*: the same species, and an area the code plausibly covers. *Ambiguous*: two of T2's ids fit Pierre's name. *Different definition*: the same species, but RAM v4.66's id joins or splits areas differently, or names a different area. A matched series may also come from a different assessment, or a different release, than the one T2's test read.

| T2's id (test, group, method, years read) | Pierre's stock | source | years | E_R | E_SSB | match |
|---|---|---|---|---|---|---|
| SABLEFEBSAIGA (MQ4, other, 1960–2014) | *Anoplopoma fimbria*, E Bering Sea, Aleutians and Gulf of Alaska | RAM | 45 | 10 | 8 | same |
| HERRCC (MQ4, primary, SCA, 1951–2015) | *Clupea pallasii*, Central Coast | RAM | 51 | 12 | 9 | same |
| HERRPRD (MQ4, primary, SCA, 1951–2015) | *C. pallasii*, Prince Rupert District | RAM | 51 | 12 | 10 | same |
| HERRHG (MQ4, primary, SCA, 1951–2015) | *C. pallasii*, Queen Charlotte Islands | RAM | 51 | 2 | 7 | same, renamed (Haida Gwaii) |
| HERRSOG (MQ4, primary, SCA, 1951–2015) | *C. pallasii*, Strait of Georgia | RAM | 51 | 7 | 9 | same |
| HERRWCVANI (MQ4, primary, SCA, 1951–2015) | *C. pallasii*, West Coast of Vancouver Island | RAM | 51 | 2 | 7 | same |
| HERRSIRS (MQ4, other, 1958–2017) | *Clupea harengus*, Celtic Sea and VIIj | RAM | 55 | 5 | 2 | probable |
| PANCHPERUNC (MQ4, other, 1963–2015) | *Engraulis ringens*, north-central Peru | RAM | 42 | 3 | 2 | same |
| CODBA2532 (MQ4, other, 1966–2012) | *Gadus morhua*, Baltic 25–32 | ICES/NAFO | 41 | 2 | 2 | same |
| CODNEAR (MQ4, other, 1946–2018) | *G. morhua*, Barents Sea (north-east Arctic) | ICES/NAFO | 91 | 8 | 8 | same |
| CODVIIek (MQ4, other, 1971–2018) | *G. morhua*, VIIe–k, Celtic Sea | RAM | 42 | 2 | 8 | same |
| CODICE (MQ4, other, 1955–2013) | *G. morhua*, Iceland | ICES/NAFO | 54 | 11 | 2 | same |
| CODIS (MQ4, other, 1968–2016) | *G. morhua*, Irish Sea VIIa | ICES/NAFO | 40 | 2 | 9 | same |
| HADFAPL (MQ4, other, 1957–2018) | *Melanogrammus aeglefinus*, Faroe | ICES/NAFO | 52 | 9 | 2 | same |
| POLLNEAR (MQ4, other, 1960–2018) | *Pollachius virens*, Arctic | ICES/NAFO | 46 | 11 | 10 | same |
| PLAICIS (MQ4, other, 1981–2018) | *Pleuronectes platessa*, Irish Sea VIIa | ICES/NAFO | 42 | 5 | 2 | same |
| SOLENS (MQ4, other, 1957–2017) | *Solea vulgaris*, North Sea | ICES/NAFO | 51 | 5 | 5 | same |
| RSOLEHSTR (MQ4, primary, TSA, 1945–2001) | *Lepidopsetta bilineata*, Hecate Strait | RAM | 49 | 9 | 3 | same |
| PHAKEPCOAST (MQ4, other, 1966–2017) | *Merluccius productus*, Pacific Coast | RAM | 43 | 10 | 2 | same |
| ESOLEPCOAST (MQ4, primary, SS2, 1876–2006) | *Parophrys vetulus*, Pacific Coast | RAM | 55 | 2 | 2 | same |
| CROCKPCOAST (MQ4, other, 1892–2016) | *Sebastes pinniger*, Pacific Coast | RAM | 47 | 9 | 2 | same |
| NROCKGA (MQ4, other, 1961–2014) | *Sebastes polyspinis*, Gulf of Alaska | RAM | 43 | 2 | 2 | same |
| WROCKPCOAST (MQ4, primary, SS3, 1916–2014) | *Sebastes entomelas*, Pacific Coast | RAM | 43 | 7 | 10 | same (MQ7's matching file names it "Widow rockfish - Pacific Coast") |
| GAGSATLC (MQ4, primary, BAM, 1962–2012) | *Mycteroperca microlepis*, South Atlantic coast | RAM | 40 | 5 | 2 | same |
| WPOLLEBS (MQ4, primary, IA, 1979–2014) | *Theragra chalcogramma*, E Bering Sea | RAM | 43 | 6 | 2 | same |
| STMARLINWCNPAC (MQ4, primary, SS3, 1975–2013) | *Kajikia audax*, W Pacific | RAM | 52 | 12 | 3 | ambiguous (or STMARLINSWPO, MQ4, primary, MULTIFAN-CL, 1952–2011; the WCNPAC assessment's 39 years read are fewer than Pierre's 52) |
| ALBASPAC (MQ5, primary, MULTIFAN-CL, 1960–2019) | *Thunnus alalunga*, S Pacific | RAM | 43 | 10 | 2 | same |
| ATBTUNAEATL (MQ5, primary, VPA, 1968–2015) | *Thunnus thynnus*, E Atlantic | ICES/NAFO | 52 | 2 | 3 | same |
| PSOLEPCOAST (MQ4, primary, SS3, 1876–2014) | *Eopsetta jordani*, N and S Pacific Coast, two stocks | RAM | 48; 43 | 5; 4 | 2; 8 | different definition (RAM v4.66 one coastwide stock) |
| HERRVIaVIIbc (MQ4, other, 1957–2017) | *C. harengus*, VIa (North) | RAM | 56 | 12 | 2 | different definition (the id joins VIa with VIIb, c) |
| MACKNWATLSA3-4 (MQ4, other, 1968–2013) | *Scomber scombrus*, Gulf of Maine to Cape Hatteras | RAM | 41 | 2 | 9 | different definition: a different area (the id names NAFO subareas 3 and 4; Pierre's area is subareas 5 and 6) |

The method and years are those of the assessment T2's test read, from its fits ("Unknown" where the test's file records none, here left blank). An independent reader of these documents checked all 53 of Pierre's species against the 277 ids; Pierre's other 21 stocks are not among them. Twenty of those 21 are among MQ3's 187 fitted stocks, on which MQ4's rate φ was chosen (ALBANATL, BIGEYECWPAC, BOCACCSPCOAST, CHILISPCOAST, COD3NO, CODFAPL, CODIIIaW-IV-VIId for both of Pierre's North Sea cod rows, GOPHERSPCOAST, HADNEAR, HADNS-IIIa-VIa, HERRNIRS, HERRNORSS, HERRNS-IIIa-VIId, MORWONGESE and MORWONGWSE, PLAICNS, POLLFAPL, POPERCHPCOAST, SPRBLKGSA29 and YFINCWPAC); only *Scomber japonicus* matches none.

**What the table says, and what it does not.**
- 28 of T2's 277 stocks have a published E, all from one study, and three more one for a stock defined differently: 24 of the MQ4 stocks matched as same or renamed, two MQ5 stocks, one probable and one ambiguous. Of MQ5's 98 stocks, which passed T2's state verdict in its primary group and which UE32's test reads, two have one, both primary (ALBASPAC, E_SSB 2; ATBTUNAEATL, 3).
- For the MQ4 rows the level MQ4 read was total biomass, while Pierre's E_SSB is for the spawning biomass: it describes another series of the same stock, and a test of T2's state on those stocks would first need a choice of series.
- In the spawning stock's own delays, T2's three numbers hold about two: by the balance they are the spawning stock now, its escapement a year back and the current catch. Pierre's E_SSB is at its floor of 2 in 13 of the 28 and above it in 15; above 3 in 12: the five British Columbia herring stocks (7 to 10), the north-east Arctic cod and saithe (8, 10), the sablefish (8), Celtic Sea and Irish Sea cod (8, 9), the widow rockfish (10) and North Sea sole (5).
- That E is chosen for the spawning stock's series alone, without the catch. T2's three numbers are the level, its recent giving and one lag, *with the draw*, and the recent giving reads the catch; a univariate E above two says that more delays of the stock alone forecast it better, not that a state of three numbers and the draw would forecast it worse. In short noisy series E is an index of what forecasts best, not a count of variables (Munch et al. 2020, Q5), and E = 2 is Pierre's floor, which half of Pierre's 53 spawning-stock series sit on (26 of them).
- So the table names no failure of T2. It names where the field's own fits found more delays useful, and so where a test with the field's criterion could most plausibly find T2's state short: the fifteen with E_SSB above 2, twelve of them above 3. All but ATBTUNAEATL (3), one of MQ5's, are MQ4's stocks, read there in total biomass. The test UE32 designs reads MQ5's stocks, on the spawning biomass MQ5 read, and its field embedding reads the escapement and the giving, both of which read the catch ([DESIGN.md](DESIGN.md)).
- Per-stock nonlinearity is not tabulated: no per-stock θ was seen.
