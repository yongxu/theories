# wen: the script as a system of signs, with 武 and 止戈 — notes

Read-only mapper, slice `wen`, 19 October 2026. The 49 entries are in `entries.json`. Every reading is the AI's. Every fragment was checked: atlas fragments by exact substring match against the `.txt` at `text_path`, and the others against the zh.wikisource pages named in `needs_source`. Every declaration was checked against an index of all `Becoming/*.lean` declarations with their namespaces, and every record against `theories/becoming/results/records/`.

## 0. Sources, and what the atlases hold

- **In the atlases.** Atlas v9.1 holds only the 說文 preface (`V4MO003`). The other texts used here are also in v9.1: 国语·郑语 (`P06`), 左传·昭公二十年 (`P07`), 荀子·正名 (`IS05`), 人物志·接识 (`XS07`), 近思录 (`S06`), 孙子 (`IS18`), 郭象注 (`XS04`) and 论语 (`R01`). The yidao atlas has none of this slice's texts.
- **Not in either atlas.** 《左传·宣公十二年》, the source of 止戈為武, and the glosses of the 說文 itself. The integrator should preserve these zh.wikisource pages:
  - `春秋左氏傳/宣公`;
  - `說文解字/01, 02, 03, 06, 07, 08, 09, 10, 12`.
- **Fragments to check on the original page.** Two were transcribed through a fetch:
  - the punctuation of 「今罪無所，而民皆盡忠，以死君命，又何以為京觀乎？」;
  - the quotation marks in the 說文 武 gloss.
- **Page variant.** The 說文 page has 悳, not 惪.
- **The 如心為恕 formula.** Its source is unlocated (perhaps a 疏). I treat it as a later re-reading and do not quote it as a fragment.
- **Overlaps with other slices.** I did not redo the Yi line: Y1 already holds 往來不窮謂之通, 感而遂通 and 咸感也. The 說文 glosses 通「達也」, 感「動人心也」 and 應「當也」 are consistent with Y1's readings and add nothing structural, except 感's phonetic, used in the phonetic-drift entry.

## 1. The slice's overall relational structure

The thesis to test: the whole script, 武/止戈 included, continues a relational ontology. The evidence splits by level.

**1. At the level of the sign system, the script is relational, and strongly so.** Its working mechanisms are relations among readings, readers and uses, and each has a checked law on the spine.

- **形聲 (most characters)** pairs two partial readings, a category and a sound, each of which lumps many words; paired, they read one word (`PartialReadout`).
- **假借** gives one graph to several words, resolved only across uses (`CrossSituational`: resolution is separation).
- **部首** is a lumping by form, right about sense only where sense goes alike across it (`Learning.selects_right_through`).
- **A phonetic component** is an installed encoding. It stays right only where speech still agrees at the encoded inputs (`References.stays_iff`).
- **Transmission** keeps the taught code, and keeps a lost distinction lost, in every generation (`ResponseLearning`).
- **Reading the past** needs dated records that separate rival histories (`Retrodiction`). Xu Shen's own critique of the 俗儒 who read clerical shapes (馬頭人為長) is exactly the no-judge law for reading through a reduction that merged components (`Readout.no_judge_of_merged`).
- **闕如** is the law that silence is sound where the evidence merges cases (`PartialReadout.silent_sound`).

On this level the thesis holds, with one correction. The relations are among signs and their users, not relations of the world encoded in graphs.

**2. At the level of graph composition, the thesis mostly fails.** Most characters are 形聲: a category and a sound, with no world-relation in the composition. The famous 會意 analyses that seem to encode relations (武 = 止 + 戈, 信 = 人 + 言, 仁 = 人 + 二, 王 = 一貫三) are Han analyses, often re-readings.

- **武.** Taken as composition, the paleographic reading (止 as foot: marching with a dagger-axe) is the better one. 說文's own gloss of 止, 「以止爲足」, supports it.
- **王.** The analyses that carry the most cosmological weight are *centered*, not relational: 王 is the one 「天下所歸往」 who 「參通」 heaven, earth and humans.
- **The radical order.** It runs from 一 to 亥 as a cosmogony: 「立一為耑…畢終於亥，知化窮冥」, with 一 「造分天地，化成萬物」. A first one divides. That is the opposite of one relational unfolding with no first element.

**3. At the level of glosses and the texts that use the characters, the relational content is real and specific.** The strongest correspondences of the slice are here, not in the graphs:

- 刘劭 on 識;
- 晏子 and 史伯 on 和;
- 荀子 on 名 and 化;
- 程颐 on 中;
- 孙子 on 間;
- 楚莊王 on 武.

They are relational in the precise sense of the method: actor and patient, knower and known differentiate within a relation, and the passage reads the relation first.

**4. 武/止戈 in particular.** The relational content lies in 楚莊王's speech, not in the graph. The speech:

- evaluates force by what it does to the loop of force (止戈);
- tests it against seven conditions, most stated through others;
- counts the enemy dead with his own (二國暴骨);
- refuses gain taken at another's juncture (利人之幾);
- sees that no result settles while 晉 stands.

Each step has an exact law (Widening, JointKeeping, Gain/Junctures, SelectionGap, Seeking's `aboveAll_never_rests`, Settling). But the frame is a frame of power: 保大, 定功, 示子孫, and the 京觀 itself kept as the rite of a 明王 against the 不敬. So the speech is a relational evaluation of force made inside a contest for standing above others. The spine states the contest's law: two seekers above all others never rest together. It does not adopt the contest's target.

## 2. Strongest correspondences (structural, ranked)

1. **刘劭《人物志·接识》 → selection through coupling, and pooled coupling.**
   - 「能识同体之善，而或失异量之美」 and 「取异体也，虽历久而不知」 match: a selection reaches exactly what couples in, and is blind beyond the coupling closure however long (`Web.selects_alike_iff`, `Flow.unselected_beyond_coupling`).
   - 「法制之人，以分数为度」 matches: a lumping cannot separate what it merges.
   - 「尽有诸流，则亦能兼达众材」 matches: a group's closure is the union of its members' (`withinClosureOf_iff`).
   - Same relation, condition and direction.
2. **晏子 和/同 → what a pool adds.**
   - 「臣献其否，以成其可」 is `Web.pool_adds`.
   - 「若以水济水」 and 「据亦同也」 are `Web.pooled_iff_member`: a member whose couplings are the pool's adds nothing.
   - The law is symmetric among members; the passage is hierarchical.
3. **楚莊王 「猶有晉在，焉得定功？」 → `Law.aboveAll_never_rests` with `Settling.settles_no_undoable`.** This is the most exact fit in the slice, and it is a fit to the structure of the frame of power, not to an ethics.
4. **荀子·正名 → `IdentifiesAlike` and `World.fixed_iff`.**
   - 同則同之 / 異則異之 and 同實者莫不同名 match `identifiesAlike_iff` and `IdentifiesAlike.unique`.
   - 二實 is counted by 所, which is a relation; 化 is identity across a step.
   - 名無固宜 is `CodeAcquisition.renaming_keeps_values`.
5. **程颐 一厅/一家/一国 → boundary-relative truth.** 中 is sub-true and not boundary-invariant (`boundaryInvariant_iff_determinate`).
6. **孙子·用间 → observation only by a route.** 「必取于人」 and 「生间者，反报也」.
7. **說文叙 on 俗儒 → `Readout.no_judge_of_merged` and `Confound.misattributes`.** 闕如 → `PartialReadout.silent_sound`, with `Identification.withBound` ("the bound buys silence").
8. **形聲 → paired partial readings.** 假借 → cross-situational resolution.
9. **止戈 → Widening, as a scope result.**
   - A loop of force closes only through a link that returns less than it received.
   - A cut closes at once and can be reopened by what follows.
   - A victory is a cut, not yet a stopping.

## 3. Divergences and non-relational strands

Each is kept as a divergence and not forced:

- **京觀 古義** (「古者明王，伐不敬，取其鯨鯢而封之…以懲淫慝」). Punitive display under a central king, with the enemy as monsters. 楚莊王 rejects the mound only because this enemy was loyal. This is the counterexample to reading 止戈 as rejecting force.
- **保大, 定功, 示子孫, 克敵必示子孫.** Force measured by a lineage's merit (`Renewable.kept_part_not_renewal`, `Clearing.center_not_derived`).
- **說文 王.** Connection routed through a center to whom all return.
- **始一終亥 with 說文 一.** A cosmogony with a first one that divides.
- **史伯 「先王以土与金木水火杂，以成百物」.** A maker outside the relation, and fixed kinds.
- **郭象 自生 and 「形景俱生…而非待也」.** It agrees in denying an outside maker (造化者无主). It diverges in denying that things give to or depend on one another, against `arises_given` and `rise_given`. This is the 注 layer, not the 庄子 text.
- **程颐 「事事物物上皆天然有个中」.** It follows his own demonstration that 中 is relative. Read as a pre-given 天理 standard, it is the slice's clearest case of a relation reread as a fixed nature.
- **說文 義 「己之威儀也」, built on 我 (which contains 戈).** The measure is the self's display.

Also noted, not entered (it belongs to another slice): 韓非 「杀戮之谓刑，庆赏之谓德」 (atlas C0091-S003) reads 德 as a lever of control, the opposite of 悳 「外得於人，内得於己」.

**書同文** is entered as scope. The loss is exact (`Law.Merges.loses`, and lost in every generation by `ResponseLearning.distinction_lost_every_generation`). The decree is a merge imposed from one center, which is not the convention formed among users that 荀子 describes.

## 4. The earlier studies: kept, extended, superseded

- **`theories/becoming/history/HANZI-AND-THEORY-TREE-2026-10-23.md` (6 October).**
  - *Kept:* the four levels of correspondence (graph composition, sense in context, compound, theory dependence); the acceptance criteria of §5 (consistent naming, faithful sense, preserved relations, compositional testability); and the 武 caution (two layers, the 左传 still endorses some campaigns).
  - *Superseded:*
    - the working gloss 「武→有约束的保护能力」;
    - the candidate table's vocabulary: "能力", "保护", "护/智" and "省/改" as correction, in the older non-relational and correction-centred terms that N7 retired;
    - the table's linear 知/辨→学/习→择→省/改→仁/义→护/智 working order.
  - *Replaced by:* the speech's structure stated by laws, the frame-of-power divergence made explicit, and selection through coupling, pooled coupling and Rejoining.
- **`HANZI-THEORY-MAP.md` (18 rows), `HANZI-LEXICAL-PILOT.md`, `HANZI-FORM-EVIDENCE.md`** (`_process/research/2026-10-05-generative-foundation-review/history/root-foundation/`).
  - Kept as evidence.
  - Superseded in vocabulary.
  - The 8-character pilot (生、化、成、习、知、智、间、系) is extended here with 說文 glosses and laws for 生, 化 (two senses), 間 and 系.
- **`theories/becoming/history/COGNITION-LI-AND-RECIPROCITY.md`.** Its hand-argued bound for 恕 is superseded by the checked `Learning.selects_right_through`: 恕 is right exactly where the other's wants go alike across the lumping of one's own.
- **The jian and wenyan line** (`sources/08-jian-wen-language/`).
  - The primitives 間→系→一 and the 位/际/化/理 duals are superseded. The spine starts from one kind of relatum (`World`/`Flow`/`Web`), takes the step index from the relata's own courses (`Interleavings`), and treats a configuration as how it relates (`configurations-alike-by-relation`).
  - The 系 entry shows why a primitive 系 misleads: 「繋也」 pictures relation as a cord, a third thing. On the spine, relation is the whole's failure to be rectangular, formed by joint action.
- **The September glossary caution on 止戈为武** (`_process/history/2026-09-consolidation/GLOSSARY.md`: moral gloss, not etymology; the community document's 「武的本义，是止息兵戈」 needs correcting). Kept and extended.
  - Extension 1: `CodeAcquisition` shows why the components cannot settle the reading (the relation between 戈 and 止 needs a composite record).
  - Extension 2: `Retrodiction` versus `CrossSituational` separates "origin of the graph" from "standing in later records". 止戈 stands among records written after its uptake; it does not retrodict the graph.
  - Ren's 生生不息论 already calls 武为止戈 a value interpretation (「作为一种价值解释」). That is the right status, and the laws above now give the value interpretation its exact range.

## 5. Question 4: a single-character controlled vocabulary

The 6 October proposal was that a controlled theory language may take single characters as unique identifiers by stipulation. The slice confirms it as stipulation and rules it out as recovery.

- **Recovery fails.** Across the records, no single sense stands for 化 (說文 「教行也」, influence taking effect, versus 荀子 「状变而实无别」, identity across change). The same holds for 識 (常/知 versus 刘劭's recognition through one's own kind), 中 (place versus the 天然 standard), 理 (治玉 versus 天理) and 道 (road versus the Laozi's 道). By `CrossSituational.stands_iff`, a sense stands only where every bearing record offers it.
- **Stipulation is possible.** A name makes sense exactly where it identifies the alike (`identifiesAlike_id_iff`), and renaming a code throughout keeps every value (名無固宜). So a controlled single-character term is a code formed among the theory's users. That is exactly gap 1 below: the spine has no law of how such a code forms.

What the current terms already do:

- **识.** Kept only for the derived structure: a formation's course factoring through its own couplings' lumping. 說文 識 「常也。一曰知也」 neither singles this out nor excludes it. The reading stands as the theory's, and its AI label should stay.
- **明.** 朙 「照也。从月从囧」: light reaching inside through an opening. This matches the passage side of 明, coupling passes what is beyond. It does not give the reflexive side, seeing the coupling one acts through.
- **理.** 「治玉也」: working along the grain matches a lumping a law goes alike across. This is structural support, not a warrant.
- **生生.** 生 「進也。象艸木生出土上」 gives arising out of a ground given by it. 生生 (reading D1) and its direction by widening are the theory's, not the graph's.
- **默** (stays silent) has a classical structural twin in 闕如.

Spine terms that lack a precise single character:

- **耦合入** (couples into). 耦 alone is paired ploughing.
- **归并** (lumping). 類 is near, but carries pre-given kinds.
- **拓宽** (widening). 廣 is a static extent.
- **关口** (juncture). 幾 in 左传 is another's peril; 易传's 幾 belongs to Y1.
- **形成体** (formation). 物 and 體 pull toward substance.
- **前段** (prefix).
- **扣留** (withholding). 戢 means sheathing force, a different structure: in the spine it is a damping link, while withholding concerns giving.

Single classical characters for these would import their text-scoped senses: substance (物, 體, 性) or power (定, 功, 王). Two-character terms remain the precise choice.

## 6. Candidate gaps, ranked (each checked absent)

How absence was checked: grep of all `Becoming/*.lean` and of both digests for convention, coordinat-, shared or common code, naming game, band, lag, overshoot, writer and generation loops. Then the nearest modules were read: `CodeAcquisition`, `ResponseLearning`, `LearnedGrouping`, `Contacts`/`References`, `ContactCourses`, `AssurancePlans.Regulation`, `CrossSituational`, `Experiment`/`Confound`.

1. **A code formed between formations (约定俗成; 書同文 as the imposed case).** Entry `xunzi-tong-ze-tong-zhi`.
   - The statement is in the entry. In brief, two formations exchanging forms for meanings keep agreement once reached, read each other's differences exactly where their codes agree, privilege no form (the course commutes with every renaming), and reach a convention fixed by starts and order. An imposed code makes all agree and loses exactly the separations each code made that it merges.
   - What exists: one-directional acquisition (supplied code, teacher) and the persistence of installed encodings. The code formed within the relation is absent.
   - This is the relational basis of any sign system, and of the theory's own vocabulary.
2. **Regulation with a late reading (宽猛相济, 济其不及以泄其过).** Entry `zuo-zhao20-kuan-meng`.
   - The spine has only the two-level `Regulation` toy with an instant response.
   - The gap is an exact least band width that grows with the lateness of the reading. A merged reading near the two ends fails, and a policy that responds only to a late reading of having left the band overshoots past both ends without end once its lag times its step exceeds a threshold set by the band (宽→慢→猛→残).
3. **Readings written back into their own evidence (the uptake of 止戈).** Entry `shuowen-wu-zhi-ge-gloss`.
   - The gap is a generational loop: each generation resolves from the last one's records and writes records through what it resolved. The resolution locks in, the earlier meaning is recoverable only from records kept from before the uptake, and where uptake records omit it the lock-in is to a wrong unique candidate.
   - Honest weight: much follows by composing `CrossSituational.candidates_append`, `narrows`, `Omitted.wrong_unique`, `ResponseLearning.every_generation_holds` and `Confound.confounded`. Its new content is only the loop.
4. **Not proposed formally: a general law for composites whose value depends on a relation between components (會意).** It goes beyond `CodeAcquisition`'s two-atom toy. It largely reduces to cross-situational resolution over candidate relations, so I did not write it as a gap object.

Also checked and found present, so not gaps:

- dependence among guards (七德's 「暴而不戢，安能保大」 is the contrapositive of `Viability.Keepable.mono`);
- sound change breaking encodings (`References.stays_iff`);
- loss across generations (`ResponseLearning`);
- pairwise-consistent senses with no global sense (`Specker.no_whole`, `Contextual.glues_iff_agree`).

## 7. Counter-review: where I may be matching words, not structure

- **Weak or partly projected entries.** Each is marked scope where the gloss is thin:
  - **間 / 閒「隟也」 as a route.** I folded it into the 用间 entry rather than claim it alone.
  - **朙「照也」.** It gives passage, not reflexivity.
  - **悳「外得於人，内得於己」 as the duality of response and coupling.** The gloss may only mean 德 = 得 in a moral-economy sense; the duality may be my projection.
  - **道「所行道也」 and `Shown`.** "The road is what is walked" may be word-level.
  - **和「相譍也」 and the response laws.** The 和/同 distinction is read in from 史伯 and 晏子, not from the gloss.
- **幾 as juncture.** 幾 in 楚莊王's speech is another's peril or critical moment. Reading it as a juncture is the AI's structural reading, not a 训诂.
- **The 京觀 refusal and `Tolerance`.** One act is not "sparing at every step". I kept it as scope, with the law correcting the passage.
- **七德 as guards ordered by `Keepable.mono`.** This imposes an inclusion (保大 within 禁暴∧戢兵) that the rhetoric only suggests.
- **形聲 and `PartialReadout`.** The pairing theorem is a channel example, and the general laws (`LumpedWithin.finer`, `exact_exists_iff`) are close to definitional. The agreement is real but not deep.
- **Selection bias.** I chose passages that carry structure. The base rate matters: most 說文 entries read 「水。出某地」 or 「从某某聲」 and carry no relational content at all. The relational character of the script is a property of the system of readings, not of the typical graph.
- **Over-weighting 說文.** Its glosses are Han, sometimes cosmological. I used modern paleography only for 武/止, with a hedge for 王; the analyses of 仁, 名, 義 and 信 may be re-readings too. I entered 仁「从人从二」 nowhere, for that reason.
- **Where the agreements come from.** The strongest agreements (刘劭, 晏子, 荀子, 程颐, 孙子) are about texts and compounds, not about the script. They support "relational thinking runs through several lines". They do not support "the 文字符号系统 encodes it".

**Overall verdict.**

- **Supported:** the script as a relational system of readings (sound-category pairing, context resolution, lumping, transmission, silence where undecided).
- **Not supported:** the graphs encoding a relational ontology. The prominent cosmological readings of graphs are centered.
- **武/止戈:** a relational evaluation of force made inside a frame of power, with exact laws for its relational steps and a recorded divergence for its frame.
