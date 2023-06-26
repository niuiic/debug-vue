git submodule update
cd ./debug
pnpm i
cd ../vue
pnpm i
sed -ri '/output.sourcemap = !!process.env.SOURCE_MAP/ a\
  output.sourcemapPathTransform = (relativeSourcePath, sourcemapPath) => { \
    const newSourcePath = path.join(path.dirname(sourcemapPath), relativeSourcePath); \
    return newSourcePath; \
  }
' ./rollup.config.js
SOURCE_MAP=true pnpm build && pnpm build-dts
rm -rf ../debug/node_modules/vue/dist/*
rsync -avzp ./packages/**/dist/* ../debug/node_modules/vue/dist
