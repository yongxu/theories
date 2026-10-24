# Original microscopy: calibrated coordinates, capture times and identity limits

8 October 2026. Continuation of [The Theory of Evolution](../../../../theories/becoming/history/THE-THEORY-OF-EVOLUTION.md), advancing requirements 3 and 5 through the empirical correspondence needed for a formation-to-outcome prediction. AI-authored analysis and substantive author counterreview; no independent-agent acceptance, new mathematical theorem or new biological experiment is claimed.

**Result.** Five original acquisitions now have source-bound image scale, complete image-directory coverage, decoded common timestamps, and inspected first/last capture records for every scene. Imaging positions within one nominal time point were acquired sequentially, with observed offsets reaching 225.89 seconds. Two rescue acquisitions retain the same scene names, region identifiers, centers, scale and boundary stage/focus positions; their corresponding boundary captures are separated by about 337.39 seconds. This supplies a recoverable observation history. It does not supply a treatment-to-well key, exact inoculation time, colony-workbook identifiers or linked later descendants.

**中文结论。** 五份原始显微文件现已核对尺度、完整图像目录、公共时间戳及每个位置的首末拍摄记录。同一名义时点的不同位置并非同时拍摄，已查偏移最大约3.76分钟；两段混合培养成像的位置配置连续，边界间隔约5.62分钟。实际图像时钟可以重建，培养条件与终点评分仍需独立对应。不得由位置标签补造处理分组、把文件名当作接种时钟，或把早期膜图像当作六日整周期后代证据。

## Preserved evidence and actual checks

The [source record](../../../../sources/evolutionary-selection/karita-2026/microscopy-metadata/README.md) preserves exact HTTP range bodies from BioImage Archive S-BIAD2117. These are portions of five CZI files, not five complete files. Every response must be HTTP 206 with the requested Content-Range, the archive-listed total length, consistent ETag and an exact byte count. Subsequent requests use If-Match; no whole-file checksum is claimed. The prior fourteen-file source manifest remains unchanged.

The [analysis package](../../../../experiments/integrated-correction/general-framework/generative-basis/ecological-selection/microscopy-correspondence/README.md) decodes the format using ZEISS's preserved `CziStructs.h`. An unmodified, pinned version of Christoph Gohlke's `czifile` separately decodes the same saved ranges. The offline sparse reader rejects unavailable bytes rather than replacing them with zeros. All **4,383 directory entries**, **388 common timestamps** and **114 first/last image-subblock records** agree across the two software routes. Complete scene-by-time grids are checked, as are dimensions, compression, pixel type and selected inline-directory correspondence. These are independent software implementations reading one dataset, not independent biological observations.

The directory records 2752 × 2208 uncompressed Gray16 pixels per image, with 14 valid bits recorded in metadata. The XML scaling values are in meters; they are distinct from the camera's 4.54 µm sensor-pixel pitch. Conversion gives the specimen-plane scales below. This verifies recorded calibration and reader correspondence, not a new calibration against a stage micrometer.

| Acquisition | Scenes × time points | Recorded scale, µm/pixel | First-to-last common timestamp, hours | Largest inspected within-time-point scene offset, seconds |
|---|---:|---:|---:|---:|
| Collapse, 23 November 2023 | 12 × 91 | 1.418750 | 15.000018 | 223.029 |
| Formation, 19 June 2024 | 12 × 91 | 7.099296 | 15.007574 | 225.888 |
| Formation, 26 June 2024 | 9 × 91 | 7.099296 | 15.000035 | 121.123 |
| Rescue, 14 October 2024, earlier file | 12 × 20 | 7.099296 | 3.167198 | 225.297 |
| Rescue, 14 October 2024, later file | 12 × 95 | 7.099296 | 15.666779 | 225.160 |

The high-resolution field spans about 3.904 × 3.133 mm; the other fields span about 19.537 × 15.675 mm. Equal pixel areas therefore do not denote equal physical colony areas across these acquisitions. The first and last high-resolution scene-0 fields are also accessed by predetermined selection in the [pixel audit](../../../../experiments/integrated-correction/general-framework/generative-basis/ecological-selection/microscopy-correspondence/frame-verification.json). Their inspection is an access and correspondence check; two endpoints cannot identify a collapse trajectory or the scored mat outcome.

## Recovering time without inventing a biological clock

The common timestamp arrays have approximately 600-second intervals. The 19 June file has an initial interval of 627.344 seconds; the remaining timings and their variation are retained. For the first scene's first and last captures, XML UTC acquisition time minus the file's acquisition origin agrees with the attached timestamp within two microseconds of the decimal/datetime decoding. This identifies seconds relative to acquisition for these values; it avoids confusing CZI producers that instead use OLE date encodings.

The common timestamp does not denote simultaneous exposure of every scene. The inspected per-image metadata reveals sequential acquisition across the plate. Using the common timestamp for a late scene can shift its observed boundary by several minutes. A trajectory calculation should use that image's own capture time. The first/last audit does not certify every interior image's individual timestamp; those records remain accessible through the checked directory.

Names such as `from-t5h`, `fromt6h`, `fromt7h` and `fromt10_5h` preserve the depositor's approximate experimental-stage labels. They are not a recorded inoculation event. Fifteen hours of acquisition are consequently not twenty-four hours of same-culture observation. This does not refute the article's experimental duration: an imaging window can start later, end earlier, or be split. It limits which endpoint or growth rate can be identified without the experiment log.

The two rescue files have identical twelve-scene identity/position metadata and matching selected stage/focus coordinates. The last capture of each earlier scene precedes that scene's first later capture by 337.387–337.398 seconds. That supports joining the *imaging-position configuration* across the restart and prevents treating the two files as automatically independent culture replicates. It does not itself certify unchanged culture contents or prove which positions received SM addition. Different file GUIDs are retained; metadata continuity is not a substitute for biological identity.

**Completed interior follow-up, 8 October 2026.** [The predefined-field trajectory study](../history/root-foundation/DEVELOPMENTAL-HISTORY-INTEGRATION.md) now checks all 91 scene-0 capture records and central-square pixels, measures detection/movement sensitivity, and inspects four assigned track endings. It distinguishes local image loss from boundary censoring. This advances the interior-history step below without resolving treatment/culture identity, physical fate or descendant linkage.

## What can and cannot be joined to outcomes

The 26 June acquisition's nine scenes and dilution-labelled path correspond at the date/count level to the nine-culture success cohort already extracted from the workbook. The 19 June acquisition has twelve positions and a path naming a dilution range. These are useful candidates for further joins, but the success workbook aggregates by date and dilution; it does not map its rows to CZI scene/region identifiers. The CZI scenes are named P1–P12 or P1–P9, and nonempty well, barcode, sample-ID, description and comment fields were not found in the inspected global metadata. A numbered imaging position is not independently a named culture or treatment assignment.

The collapse workbook's 784 areas still lack image, time and scene keys. The source's figure reports 769 colonies. Verifying the high-resolution scale does not resolve that discrepancy or identify which contours contributed to either count. A new measurement must retain its own segmentation, contour and exclusion records rather than selecting 769 objects to reproduce the caption. Interior captures, registration and separation of disappearance from motion, focus loss or merging are necessary before estimating a collapse-size distribution.

Instrument timeline records in the June files include incubation-controller values and disabled channels. These are not a calibrated measurement of the liquid's temperature and do not identify the cause of the between-date outcome reversal. The article's culture methods and these device records retain their distinct evidential roles.

## Affirmative connection and substantive counterreview

The generative account needs the actual history through which a developed structure changes continuation. Here observation is itself a differentiated activity within that history: a moving stage acquires positions at different times and magnifications. Accounting for that relationship prevents an image-index abstraction from supplying a false simultaneous state or a common physical scale. This is an omitted measurement relationship now recovered, not a refutation of the underlying developmental proposal.

The strongest conventional spatial/developmental model receives exactly the same calibration, acquisition records and uncertainty. Neither ordinary metadata decoding nor image access establishes a uniquely generative prediction. Its contribution is to constrain a future joint test and remove unsupported substitutions. A rule that simply fits a new terminal-success probability to each date would leave the targeted explanatory connection unresolved.

Three adversarial checks limit the affirmative conclusion. First, identical scene coordinates can coexist with changed material handling; the rescue join is explicitly scoped to imaging configuration. Second, an observed disappearing bright object need not be a falling colony; no event count is inferred from the two inspected endpoint fields. Third, the present 24-hour plate experiment and the separate six-day lineage experiment differ in geometry, strains and scoring. No biological connection is created by putting their records on one graph.

**Next decisive connection:** decode the interior high-resolution sequence at a declared scene; reconstruct physical size, motion and disappearance with image-specific timing and uncertainty; then connect independently specified formation measurements to an identified culture's scored endpoint. Resolve or explicitly bound the scene-to-treatment and endpoint join before the held-out comparison. Whole-cycle prediction additionally needs the actual later sampling, inherited reconstruction and descendant records. The concurrently [completed evolutionary-organization account](../history/root-foundation/EVOLUTIONARY-ORGANIZATION-INTEGRATION.md) already supplies the conditional sampled-state-to-redevelopment connection; it is credited and not restarted here.

No new Lean proof is required for these source-decoding and numerical correspondence checks because no new mathematical theorem is asserted. Existing checked mathematical and explicit-axiom ethical results retain their scopes. The full six evolutionary completion requirements and the unestablished broad comparative claim remain unchanged.
