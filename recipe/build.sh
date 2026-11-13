#!/usr/bin/env bash
set -euxo pipefail

# MESON_ARGS (conda-build) already sets the prefix, libdir and buildtype
meson setup forgebuild ${MESON_ARGS} --wrap-mode=nofallback --backend=ninja
ninja -C forgebuild -j"${CPU_COUNT}" -v
ninja -C forgebuild install

# CMDOMAIN/CMROOT/CMMGR/CMDOMAINS defaults and a localhost CmDomains file,
# as conda-forge's cm sets them up
for d in activate deactivate; do
  mkdir -p "${PREFIX}/etc/conda/${d}.d"
  for ext in sh csh fish; do
    cp "${RECIPE_DIR}/scripts/${d}.${ext}" "${PREFIX}/etc/conda/${d}.d/cm-${d}.${ext}"
  done
done
