require 'rubygems'
require 'spec'
require 'date'

require File.join(File.dirname(__FILE__), '/../lib/metric_fu.rb')
include MetricFu

Mystat = <<-EOF
(in /Users/gmcinnes/Documents/projects/NeerBeer/src/Web)
+----------------------+-------+-------+---------+---------+-----+-------+
| Name                 | Lines |   LOC | Classes | Methods | M/C | LOC/M |
+----------------------+-------+-------+---------+---------+-----+-------+
| Controllers          |   893 |   405 |      16 |      41 |   2 |     7 |
| Helpers              |   569 |   352 |       0 |      52 |   0 |     4 |
| Models               |  1758 |   453 |      26 |      48 |   1 |     7 |
| Libraries            |  2507 |  1320 |      19 |     175 |   9 |     5 |
| Model specs          |  2285 |   965 |       0 |       1 |   0 |   963 |
| View specs           |   821 |   654 |       0 |       2 |   0 |   325 |
| Controller specs     |  1144 |   871 |       0 |       9 |   0 |    94 |
| Helper specs         |   652 |   465 |       0 |       1 |   0 |   463 |
| Library specs        |  1456 |  1141 |       8 |      14 |   1 |    79 |
+----------------------+-------+-------+---------+---------+-----+-------+
| Total                | 12085 |  6626 |      69 |     343 |   4 |    17 |
+----------------------+-------+-------+---------+---------+-----+-------+
  Code LOC: 2530     Test LOC: 4096     Code to Test Ratio: 1:1.6

EOF

