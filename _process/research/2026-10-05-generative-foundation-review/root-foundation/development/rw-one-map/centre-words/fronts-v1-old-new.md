# WM2, second part: the front pages, old and new (final drafts as applied on branch wm2-fronts)

*AI-written, 13 November 2026. Each item: the file, the old string, the new string, and how many places.*

## English

### _process/navigation/README-FIRST-SCREEN.md

**1.** (1 place)

OLD: Its centre: a selection can meet its own criterion while what it cannot read is lost. Whether that loss counts forms within becoming too, in what people and AI come to read; the theorems, which read only the dynamics, do not settle it

NEW: Its centre: a selection can go on meeting its own criterion while something is used up whose loss makes no difference to it. Whether that loss counts forms within becoming too, in people and AI; the theorems state the dynamics and do not settle it

**2.** (1 place)

OLD: Four questions for any selection, a reward, a judge, a market or a vote: what does it read or need; what lies beyond that; can it do better on what it reads by lowering what lies beyond; can its rule lock on what it already selected. A judge has a fifth: who reads the loss, and when.

NEW: Of any selection, a reward, a judge, a market or a vote, ask four things: what can make a difference to it; what makes none; whether there is room (is every allowed outcome that leaves more of what makes none beaten, on what makes a difference, by another?); and, where its rule is set again at each update from the share it already favours, whether it can lock. Of a judge ask a fifth: whose judgment can change with the loss, and when.

**3.** (1 place)

OLD: [when doing best on what is read must drain what lies beyond]

NEW: [when a selection at its best on what makes a difference to it, with room, leaves what makes none as low as any allowed outcome does]

**4.** (1 place)

OLD: ), as far as any allowed outcome does, and when a rule read from the share of its own winners, favouring them, locks on them, without noise, while a loss it does not read grows.

NEW: ), and when a rule set again from the share it already favours stays locked, without noise, however large a loss grows that makes no difference either to what is selected next or to the rule.

**5.** (1 place)

OLD: refit to the clicks its own top results draw, its success read from those same clicks,

NEW: refit to the clicks its top results draw, its success measured by those same clicks,

### theories/becoming/USES.md

**1.** (1 place)

OLD: You can ask four questions of any selection, whether a reward, a judge, a market or a vote: what it reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected. A judge has a fifth: who reads the loss, and when.

NEW: Of any selection, whether a reward, a judge, a market or a vote, you can ask four things: what can make a difference to it; what makes none; whether there is room (is every allowed outcome that leaves more of what makes none beaten, on what makes a difference, by another?); and, where its rule is set again at each update from the share it already favours, whether it can lock. Of a judge, a fifth: whose judgment can change with the loss, and when.

### theories/becoming/USES-EXAMPLES.md

**1.** (1 place)

OLD: The four questions for any selection, then a fifth for a judge:

NEW: The four things to ask of any selection, then a fifth for a judge:

**2.** (2 places)

OLD: 1. **What the judge reads.**

NEW: 1. **What makes a difference to the judge.**

**3.** (2 places)

OLD: 2. **What its selection can reach.**

NEW: 2. **What makes no difference to it.**

**4.** (2 places)

OLD: 5. **Who reads the loss, and when.**

NEW: 5. **Whose judgment can change with the loss, and when.**

**5.** (1 place)

OLD: | 1. What the judge reads |

NEW: | 1. What makes a difference to the judge |

**6.** (1 place)

OLD: | 2. What its selection can reach |

NEW: | 2. What makes no difference to it |

**7.** (1 place)

OLD: | 5. Who reads the loss, and when |

NEW: | 5. Whose judgment can change with the loss, and when |

**8.** (1 place)

OLD: 2. *Who reads the loss, and when?*

NEW: 2. *Whose judgment can change with the loss, and when?*

### MAP.md

**1.** (1 place)

OLD: it asks what the selection reads or needs, what lies beyond that, whether it can do better on what it reads by lowering what lies beyond, and whether its rule can lock on what it already selected;

NEW: it asks what can make a difference to it, what makes none, whether there is room (every allowed outcome that leaves more of what makes none being beaten on what makes a difference), and, where its rule is set again from the share it already favours, whether it can lock;

### theories/becoming/ONE-PAGE.md

**1.** (1 place)

OLD: | **What sustains it, and what can see its loss?** |

NEW: | **What sustains it, and to what does its loss make a difference?** |

**2.** (1 place)

OLD: The selections through a selector's couplings (what it reads or needs), together, reach exactly what couples into it

NEW: The selections through a selector's couplings (what can make a difference to it), together, reach exactly what couples into it

**3.** (1 place)

OLD: With *room* (every eligible outcome left higher beyond is beaten on what couples in), every optimum of an order rising with what couples in drains what lies beyond as far as any eligible outcome does

NEW: With *room* (every eligible outcome that leaves any of what makes no difference higher than another does is beaten on what makes a difference), every optimum of an order rising with what makes a difference, whatever it counts after, leaves the rest as low as any eligible outcome does

**4.** (1 place)

OLD: A rule read from the share it raises can lock and outlive a growing loss it does not read

NEW: A rule set again only from the share it already favours can lock and, on its conditions, stay locked however large a loss grows that makes no difference either to what is selected next or to the rule

### tools/research/navigation.py

**1.** (1 place)

OLD: 'The selections through a selector\'s couplings (what it reads or needs), together, reach exactly what couples into it'

NEW: 'The selections through a selector\'s couplings (what can make a difference to it), together, reach exactly what couples into it'

**2.** (1 place)

OLD: 'A rule read from the share it raises can lock and outlive a growing loss it does not read'

NEW: 'A rule set again only from the share it already favours can lock and, on its conditions, stay locked however large a loss grows that makes no difference either to what is selected next or to the rule'

**3.** (1 place)

OLD: 'With *room* (every eligible outcome left higher beyond is beaten on what couples in), every optimum of an order rising with what couples in drains what lies beyond as far as any eligible outcome does'

NEW: 'With *room* (every eligible outcome that leaves any of what makes no difference higher than another does is beaten on what makes a difference), every optimum of an order rising with what makes a difference, whatever it counts after, leaves the rest as low as any eligible outcome does'

### tools/research/tests/test_uses_pages.py

**1.** (1 place)

OLD: self.assertIn('four questions of any selection', page(USES))

NEW: self.assertIn('you can ask four things', page(USES))

**2.** (1 place)

OLD: self.assertIn('The four questions for any selection, then a fifth for a judge', page(EXAMPLES))

NEW: self.assertIn('The four things to ask of any selection, then a fifth for a judge', page(EXAMPLES))

### tools/research/the_map.py

**1.** (1 place)

OLD: Under each of the four questions stands the number of general theorems that conclude it;

NEW: Under each of the four marks (begins, lasts, changes, ends) stands the number of general theorems that conclude it;

**2.** (1 place)

OLD: It answers none of the '         'four questions of the course itself and fills no square.'

NEW: It concludes none of the '         'four marks of the course itself and fills no square.'

## Chinese

### _process/navigation/README-ZH.md

**1.** (1 place)

OLD: 一个选择可以达到其自身之标准，而它读不到的东西却失去了。这一损失算不算数，也在生灭变化之中形成，在人与 AI 读到的东西里形成；诸定理只读动态，并不决定它

NEW: 一个选择可以一直达到其自身之标准，而某样东西却在耗减，这耗减对它不造成差别。这一损失算不算数，也在生灭变化之中形成，形成于人与 AI 之中；诸定理陈述动态，并不决定它

**2.** (1 place)

OLD: 都可以问四个问题：它读取或需要什么；什么在这之外；它能不能靠压低外部之物，在所读之物上做得更好；它的规则能不能锁定在它已选中的东西上。评判者还有第五问：谁读到损失，何时读到。

NEW: 都可以问四件事：什么能对它造成差别；什么对它不造成差别；有没有余地（每一个把不造成差别者留得更多的容许结果，是否都在造成差别者上被另一个容许结果胜过？）；以及，在它的规则每次更新都由它已偏向的份额重新定出之处，它能不能锁定。对评判者还要问第五件：谁的判断能随损失而变，何时变。

**3.** (1 place)

OLD: [在什么条件下，在所读之物上做到最好，必定使外部之物耗竭](../../theories/becoming/ONE-PAGE.zh.md)，耗竭的程度不亚于任何容许的结果；以及，在无噪声时，一条由自身胜者所占份额来定、偏向这些胜者的规则，在什么条件下会锁定在它们身上，而它读不到的损失不断增长。

NEW: [一个选择在对它造成差别者上做到最好之处，只要有余地，对它不造成差别者，任何容许的结果把它留到多低，它就留到多低](../../theories/becoming/ONE-PAGE.zh.md)；以及，在无噪声时，一条由它已偏向的份额重新定出的规则，在什么条件下一直锁定，不论那对下一步所选出的与规则都不造成差别的损失增长到多大。

**4.** (2 places)

OLD: 按它自己排在前面的结果引来的点击重新拟合

NEW: 按它排在前面的结果引来的点击重新拟合

### theories/becoming/USES.zh.md

**1.** (1 place)

OLD: 你都可以问四个问题：它读取或需要什么；什么在这之外；它能不能靠压低外部之物，在所读之物上做得更好；它的规则能不能锁定在它已经选中的东西上。评判者还有第五问：谁读到损失，何时读到。

NEW: 你都可以问四件事：什么能对它造成差别；什么对它不造成差别；有没有余地（每一个把不造成差别者留得更多的容许结果，是否都在造成差别者上被另一个容许结果胜过？）；以及，在它的规则每次更新都由它已偏向的份额重新定出之处，它能不能锁定。对评判者，还有第五件：谁的判断能随损失而变，何时变。

### theories/becoming/USES-EXAMPLES.zh.md

**1.** (1 place)

OLD: 先是对任何选择都问的四个问题，再是对评判者的第五个：第二、第三与第四个，由诸定理在其前提之下回答；第一个是一种读法，第五个是一个经验问题。

NEW: 先是对任何选择都要问的四件事，再是对评判者的第五件：第二、第三与第四件，由诸定理在其前提之下回答；第一件是一种读法，第五件是一个经验问题。

**2.** (2 places)

OLD: 1. **评判者读取什么。**

NEW: 1. **什么对评判者造成差别。**

**3.** (2 places)

OLD: 2. **它的选择能到达什么。**

NEW: 2. **什么对它不造成差别。**

**4.** (2 places)

OLD: 5. **谁读取损失，何时读取。**

NEW: 5. **谁的判断能随损失而变，何时变。**

**5.** (1 place)

OLD: | 1. 评判者读取什么 |

NEW: | 1. 什么对评判者造成差别 |

**6.** (1 place)

OLD: | 2. 它的选择能到达什么 |

NEW: | 2. 什么对它不造成差别 |

**7.** (1 place)

OLD: | 5. 谁读取损失，何时读取 |

NEW: | 5. 谁的判断能随损失而变，何时变 |

**8.** (1 place)

OLD: 2. *谁读取损失，何时读取？*

NEW: 2. *谁的判断能随损失而变，何时变？*

### theories/becoming/ONE-PAGE.zh.md

**1.** (1 place)

OLD: | **什么维持它，什么能看见它的失去？** |

NEW: | **什么维持它，它的失去对什么造成差别？** |

**2.** (1 place)

OLD: 选择者读取什么、需要什么，这些就是它的*耦合*；

NEW: 能对选择者造成差别的，就是它的*耦合*；

**3.** (1 place)

OLD: | | 不耦合进选择者的东西在*外部*。

NEW: | | 不耦合进选择者的东西，对经由这些耦合的选择不造成差别，这里称作*外部*。

**4.** (1 place)

OLD: 一条规则提高某类东西的份额，它自己又是由这个份额定出的。这样的规则可以*锁定*：此后规则和份额都不低于起点；它读不到的损失不断增长，规则照旧存续（

NEW: 一条规则，每一步都只由它已偏向的份额重新定出，可以*锁定*，并在其条件下一直锁定：此后规则和份额都不低于起点，不论那对下一步所选出的与规则都不造成差别的损失增长到多大（

**5.** (1 place)

OLD: *耦合*：一个选择者读取或需要的东西；

NEW: *耦合*：能对一个选择者造成差别的东西；

**6.** (1 place)

OLD: *外部*：不耦合进选择者的东西；

NEW: *外部*：不耦合进选择者、对经由这些耦合的选择不造成差别的东西；
