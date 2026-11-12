# AI-written, 12 November 2026. The lock path in the order of the ring, with the link that closes it.
# Edits data/paths.json once (it refuses to run twice).
import json, os
HERE = os.path.dirname(os.path.abspath(__file__))
p = os.path.join(HERE, 'data', 'paths.json')
d = json.load(open(p, encoding='utf-8'))
lock = next(x for x in d['paths'] if x['id'] == 'lock')
sec = lock['sections'][0]
assert len(sec['steps']) == 5, 'already edited'
s1, s2, s3, s4, s5 = sec['steps']
new = {'say_en': 'While it is locked, what it does not count goes on being used up. The laws take this growth as given; they do not derive it.',
       'say_zh': '定住的时候，它不算的东西照旧在被耗掉。这一点，定律是当作给定的，没有去推出来。',
       'on': ['b1.held>b2.uncounted']}
sec['steps'] = [s1, s2, new, s4, s5, s3]
lock['shows_en'] = [
    'Proved (steps 2, 5, 6, 7): the lock itself, each under the condition its sentence gives.',
    'Taken as given by the laws (step 3): that what is not counted goes on being used up while the lock stands.',
    'Only in built examples (step 4): that what would read the loss is removed.',
    'The way out. Proved of the course itself (step 9; step 8 says what "in time" means): exactly when a loss that has reached what sets the rule in time turns it. Every other way out drawn (steps 10 to 13) is proved only with something given from outside the course: a judging that stops favouring past a set loss, a loss that falls on what shapes the rule, a measure over a fixed list, a limit on what is allowed. No law drawn says what makes a loss reach what sets the rule, or come to be counted. One built case (under step 10) shows a lock left with nothing counting the loss: the loss fell on what the rule favoured.',
    'In no law (steps 17, 18): what first brings a rule to be updated from its own picks, and the loop reaching its own checks.']
lock['shows_zh'] = [
    '已证明的（第 2、5、6、7 步）：定局本身，各在句子里写明的条件之下。',
    '定律当作给定的（第 3 步）：定局还在的时候，它不算的东西照旧在被耗掉。',
    '只有造出来的例子的（第 4 步）：读得到损耗的被清走。',
    '出路。过程自己的定律（第 9 步；第 8 步说的是“及时”指什么）：损耗及时传到定规则的一方之后，恰好在什么条件下规则会转向。其余画出的每一条出路（第 10 到 13 步），都只在有过程之外给定的东西时才得到证明：一种损耗过了定量就不再偏向的评法，落在改规则一方身上的损耗，按一份固定名单来量，对允许结果的一条限制。损耗怎样才传得到定规则的一方、怎样才被算进去，画出的定律里没有一条说。有一个造出来的例子（在第 10 步下面）：没有任何一方去算损耗，定局也破了，因为损耗落在了规则偏向的一方身上。',
    '没有定律的（第 17、18 步）：规则最初怎样变成照自己选出的结果改；这个圈怎样伸到查错的途径上。']
json.dump(d, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('lock path:', [len(S['steps']) for S in lock['sections']])
