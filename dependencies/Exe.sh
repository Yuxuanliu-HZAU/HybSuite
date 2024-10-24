script_dir2="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -s "${script_dir2}/BMGE-main/src/BMGE.jar" ]; then
cd ${script_dir2}/BMGE-main/src
javac BMGE.java
echo Main-Class: BMGE > MANIFEST.MF
jar -cmvf MANIFEST.MF BMGE.jar BMGE.class bmge/*.class
rm MANIFEST.MF BMGE.class bmge/*.class
fi
