# The Zhou books: Chinese Wikisource revisions

Retrieved on 10 November 2026 through the MediaWiki API of zh.wikisource.org, for TM's reading of the Zhou texts onto the map. Each page is kept at the revision named in the [provenance](PROVENANCE.json), with the SHA-256 of its bytes and of its wikitext. The texts are pre-modern and in the public domain; Wikisource's punctuation and markup are CC BY-SA 4.0. This is a punctuated electronic edition, not a scan, and it is not collated with a printed edition.

- `shangshu-*.json`: eleven chapters of 《尚書》. 皐陶謨, 康誥, 酒誥, 召誥, 無逸, 洪範, 盤庚上 and 多方 belong to the 今文 text. 泰誓上, 泰誓中 and 大禹謨 are chapters of the 古文 text, compiled after the Han; a line from them is used only where a pre-Qin text quotes it. The pages carry modern editorial notes and variant readings.
- `guoyu-*.json`: three books of 《國語》: 周語上 (卷一), 周語下 (卷三) and 鄭語 (卷十六).
- `zuozhuan-*.json`: five reigns of 《春秋左氏傳》: 桓公, 莊公, 僖公, 襄公 and 昭公, each with its 經 and 傳.

The [reading](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/tm-traditions-onto-the-map/pilot/ZHOU.md) quotes these revisions, and its builder checks every quotation against them. Retaining whole pages does not imply reading them whole.
