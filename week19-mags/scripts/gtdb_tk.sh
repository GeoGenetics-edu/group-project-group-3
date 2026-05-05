#!/bin/bash
#SBATCH --job-name=gtdbtk
#SBATCH --output=/maps/projects/course_1/scratch/group3/logs/gtdbtk_%j.out
#SBATCH --error=/maps/projects/course_1/scratch/group3/logs/gtdbtk_%j.err
#SBATCH --cpus-per-task=30
#SBATCH --mem-per-cpu=6G         # GTDB-Tk R232 requires ≥140 GB RAM (30*6=180 GB)
#SBATCH --time=10:00:00
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=xkz321@alumni.ku.dk
#SBATCH --reservation=NBIB25004U
#SBATCH --account=teaching


# ============== Define help (-h) text/function ==============
show_help() {
    echo ""
    echo "Usage: $(basename "$0") [-h] [-i INPUT_DIR] [-o OUT_DIR] [-d DATABASE]" 
    echo ""
    echo "Runs GTDB-Tk on MAGs to taxonomically clasify them"
    echo ""
    echo "Options:"
    echo "  -h                      Print this help text"
    echo "  -i      INPUT_DIR       Input directory containing MAGs (required)"
    echo "  -o      OUT_DIR         Output directory to store results in (required)"
    echo "  -d      DATABASE        Database that GTDB-Tk should use for taxonomic classification"
    echo "                          (default: /maps/projects/course_1/data/gtdb232/release232)"
    echo ""
    exit 0
}

# ============== Set error handling to make script safer ==============
set -euo pipefail


# ============== Define default variable values ==============
INPUT_DIR=""
OUT_DIR=""
DB="/maps/projects/course_1/data/gtdb232/release232"

# ============== Parse flags ==============
while getopts "hi:o:d" opt; do
    case $opt in
        h)
            show_help
            ;;
        i)
            INPUT_DIR="$OPTARG"
            ;;
        o)
            OUT_DIR="$OPTARG"
            ;;
        d)
            DB="$OPTARG"
            ;;
    esac
done


# ============== Load GTDB-Tk environment ==============
module load gtdbtk
export PATH=/opt/shared_software/shared_envmodules/conda/gtdbtk-2.7.0/bin:$PATH
export GTDBTK_DATA_PATH="$DB"


# ============== Safety checks (GTDB-Tk installation and folder paths) ==============
gtdbtk --version
command -v gtdbtk >/dev/null 2>&1 || {
    echo "ERROR: gtdbtk not found"
    exit 1
}

[[ -d "$INPUT_DIR" ]] || { echo "❌ Missing input dir"; exit 1; }
[[ -d "$DB" ]] || { echo "❌ Missing GTDB database"; exit 1; }

mkdir -p "$OUT_DIR"

# ============== Print code run summary ==============
echo "Running GTDB-Tk..."
echo "Input:  $INPUT_DIR"
echo "Output: $OUT_DIR"

# ============== Run GTDB-Tk ==============
gtdbtk classify_wf \
    --genome_dir "$INPUT_DIR" \
    --out_dir "$OUT_DIR" \
    --cpus 30 \
    --extension fa \
    --place_species
echo "Done."

# ============== Find abundant MAGs and save them ==============
# Extracts column 2 from the GTDB-Tk summary file
#cut -f2 "$OUT_DIR/gtdbtk.bac120.summary.tsv" | grep -oP 's__[^;]*' | sort | uniq -c | sort -rn | head > "$OUTDIR/"
#cut -f2 "$OUT_DIR/08_gtdbtk/08_taxa_gtdbtk/gtdbtk.bac120.summary.tsv" | grep -oP 's__[^;]*' | sort | uniq -c | sort -rn > "$OUTDIR/"
