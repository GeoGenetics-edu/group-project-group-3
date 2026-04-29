# NBIB25004U — Metagenomics Analyses for Microbiomes 2026

## Group _N_

| Member | KU-ID |
|--------|-------|
| _Name_ | _abc123_ |
| _Name_ | _abc123_ |
| _Name_ | _abc123_ |
| _Name_ | _abc123_ |

## Links

- [Course wiki (practical instructions)](https://github.com/GeoGenetics/NBIB25004U-Metagenomics-2026/wiki)
- [Main course repository](https://github.com/GeoGenetics/NBIB25004U-Metagenomics-2026)
- [Mjolnir HPC documentation](https://mjolnir-ucph.dk/)

## Teaching Team

| Name | Email |
|------|-------|
| Urvish Trivedi | urvish.trivedi@bio.ku.dk |
| Antonio Fernandez-Guerra | antonio.fernandez-guerra@sund.ku.dk |
| Søren J. Sørensen | sjs@bio.ku.dk |
| Morten T. Limborg | morten.limborg@sund.ku.dk |
| Jonas Coelho Kasmanas | jonas.kasmanas@bio.ku.dk |
| Yunjeong So | yunjeong.so@sund.ku.dk |
| Sam Williams | sam.williams@sund.ku.dk |
| Bryant Chambers | bryant.chambers@sund.ku.dk |
| Guillermo Rangel | guillermo.pineros@sund.ku.dk |
| Mateu Menéndez-Serra | mateu.menendez@sund.ku.dk |
| Antton Alberdi | antton.alberdi@sund.ku.dk |
| Amalia Bogri | amalia.bogri@sund.ku.dk |

## Repository structure

```
.
├── scripts/                       # Your own utility scripts
├── week18-preprocessing/          # Read QC, assembly, and binning
├── week19-mags/                   # MAG characterisation (taxonomy & function)
├── week20-community-analysis/     # Diversity metrics, phyloseq, ordination
├── week21-differential/           # Differential abundance, ML methods
├── project/                       # Weeks 22–24: group project workspace
└── report/                        # Final group report
```

## Getting started on Mjolnir

You will work on the [Mjolnir HPC](https://mjolnir-ucph.dk/). Before you can clone or push to GitHub, you must set up **SSH key authentication** — GitHub no longer accepts passwords, and Mjolnir has no browser for OAuth.

### One-time setup (do this once, on Mjolnir)

**1. Configure your git identity**

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@ku.dk"
```

**2. Generate an SSH key** (press Enter at every prompt, including the passphrase if you don't want one):

```bash
ssh-keygen -t ed25519 -C "your.email@ku.dk"
```

**3. Print your public key:**

```bash
cat ~/.ssh/id_ed25519.pub
```

**4. Add the key to your GitHub account:**

- Copy the entire output of the previous command (starts with `ssh-ed25519 ...`)
- Go to https://github.com/settings/ssh/new
- Title: `Mjolnir` — Key: paste — click **Add SSH key**

**5. Test the connection:**

```bash
ssh -T git@github.com
```

You should see: _"Hi `<username>`! You've successfully authenticated..."_

### Cloning your group repository

After the team has been created in GitHub Classroom, **always clone with the SSH URL** (not HTTPS):

```bash
git clone git@github.com:GeoGenetics-edu/group-project-<your-team>.git
cd group-project-<your-team>
```

### If you already cloned with HTTPS

You will get an authentication error on `git push`. Fix it by switching the remote to SSH:

```bash
git remote set-url origin git@github.com:GeoGenetics-edu/group-project-<your-team>.git
git remote -v   # confirm both URLs now start with git@github.com
```

### Basic git workflow

```bash
git pull                  # Pull your teammates' changes (do this BEFORE you start working)
git add <files>           # Stage your changes
git commit -m "message"   # Commit with a meaningful message
git push                  # Push to the shared repo
```

**Best practices:**

- Commit early and often. Write meaningful commit messages.
- Always `git pull` before you start working to avoid conflicts.
- Make sure all group members contribute commits — your activity is visible.
- Never commit large data files (FASTQ, BAM, fasta, databases). The `.gitignore` is pre-configured to block these.

### Common errors

| Error | Cause / Fix |
|-------|-------------|
| `Permission denied (publickey)` | SSH key not added to GitHub yet, or you cloned with HTTPS. Run the SSH setup above. |
| `remote: Support for password authentication was removed` | You cloned with HTTPS. Switch to SSH with `git remote set-url`. |
| `fatal: refusing to merge unrelated histories` | Use `git pull --allow-unrelated-histories` once, then resolve conflicts. |
| `Updates were rejected because the remote contains work that you do not have` | Run `git pull` first, resolve conflicts, then `git push`. |
| `Author identity unknown` | You skipped step 1. Set `user.name` and `user.email`. |

If you get stuck, ask in the course channel or contact a TA.
