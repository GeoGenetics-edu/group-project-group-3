#!/bin/bash
#SBATCH --job-name=extract_hq_mags
#SBATCH --output=/maps/projects/course_1/scratch/group3/logs/extract_hq_mags_%x_%j.out   # stdout log
#SBATCH --error=/maps/projects/course_1/scratch/group3/logs/extract_hq_mags_%x_%j.err    # stderr log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:30:00
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=xkz321@alumni.ku.dk
#SBATCH --reservation=NBIB25004U
#SBATCH --account=teaching


# ============== Define help (-h) text/function ==============
show_help() {
    echo ""
    echo "Usage: $(basename "$0") [-h] [-m MAGS_DIR] [-i INPUT_QUALITY_FILE] [-e FILE_EXTENSION] [-o OUTPUT_DIRECTORY]"
    echo ""
    echo "Filters and copies high quality mags into an output folder"
    echo ""
    echo "Options:"
    echo "  -h                              Shows this help message"
    echo "  -m      MAGS_DIR                Directory containing mags (defualt: /maps/projects/course_1/people/fvb335/07_all_hq_mags/)"
    echo "  -i      INPUT_QUALITY_FILE      CheckM2 quality file to use for filtering mags"
    echo "                                  (default: /maps/projects/course_1/people/fvb335/06_quality_checkm2/quality_report.tsv)"
    echo ""
    echo "  -e      FILE_EXTENSION          The extension/filetype of the mag files (default: fa)"
    echo "  -o      OUTPUT_DIRECTORY        Directory to ouput the copied high quality mags (required)"
    echo ""
    exit 0
}

# ============== Set error handling to make script safer ==============
set -euo pipefail

# ============== Input and output files/folders (set default values) ==============
MAGS_DIR="/maps/projects/course_1/people/fvb335/07_all_hq_mags/"
CHECKM2_file="/maps/projects/course_1/people/fvb335/06_quality_checkm2/quality_report.tsv"
HQ_DIR=""
EXTENSION="fa"

# ============== Parsing flags ==============
while getopts "hmieo:" opt; do
    case $opt in
        h)
            show_help
            ;;
        m)
            MAGS_DIR="$OPTARG"
            ;;
        i)
            CHECKM2_file="$OPTARG"
            ;;
        e)
            EXTENSION="$OPTARG"
            ;;
        o)
            HQ_DIR="$OPTARG"
            ;;
        \?)
            exit 1 # Automatically print error if flag is unknown.
            ;;
    esac
done
    


# ============== Checking that the MAG directory and CheckM2 file exists ==============
echo "Checking inputs..."
[[ -d "$MAGS_DIR" ]] || { echo "❌ Missing directory: $MAGS_DIR"; exit 1; }
[[ -f "$CHECKM2_file" ]] || { echo "❌ Missing file: $CHECKM2_file"; exit 1; }
echo "✅ Inputs look good"


# Create the output directory
mkdir -p "$HQ_DIR"

# ============== Print summary of the code run ==============
echo "=========================================="
echo "Starting HQ MAG extraction"
echo "Input dir:  $MAGS_DIR"
echo "Report:     $CHECKM2_file"
echo "Output dir: $HQ_DIR"
echo "Criteria:   Completeness > 90 % AND Contamination < 5 %"
echo "=========================================="


# ============== Core script ==============
count=0
while read -r mag; do
    # Define input/output file paths
    src="${MAGS_DIR}/${mag}.${EXTENSION}"
    HQ_MAGS="${HQ_DIR}/${mag}.${EXTENSION}"

    echo "Processing: $mag"

    # Skip if there are already processed files
    if [[ -f "$HQ_MAGS" ]]; then
        echo "Skipping $mag (already exists)"
        continue
    fi
   
    # Copy MAG to HQ folder
    cp "$src" "$HQ_MAGS"
    ((++count))

# End loop
done < <(awk -F '\t' 'NR>1 && $2 > 90 && $3 < 5 {print $1}' "$CHECKM2_file")


# ============== Print finish summary ==============
echo "=========================================="
echo "Finished."
echo "Total MAGs copied: $count"
echo "Output folder:     $HQ_DIR"
echo "=========================================="


