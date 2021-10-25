#!/bin/bash
cd $HOME/Pictures/Bing

cat > background.xml << EOF
<background>
  <starttime>
    <year>2021</year>
    <month>03</month>
    <day>14</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
EOF

for image in *.jpg
do
cat >> background.xml << EOF
  <static>
    <duration>300.0</duration>
    <file>$PWD/$image</file>
  </static>
EOF
done

cat >> background.xml << EOF
</background>
EOF

