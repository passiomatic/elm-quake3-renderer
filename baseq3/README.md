# Quake 3 Resources

This folder is where you should extract the resources from your own copy of Quake 3 to be able to load the maps (those `.pk3` files are regular Zip files with a different extension). And yes, you have to provide your own resources, I'm not going to redistribute id's property. 

## Resource preparation

There are some changes and limitations that you will need to consider before using the original game resources: 

 * Any texture TGA file that you need must be converted to PNG.
 * For optimal results you should make sure that all textures dimensions are a power of two (64, 128, 256, 1024, etc). This is not always possible since the original Quake 3 Arena textures sometimes have weird sizes (e.g. 256×320). To cope with this WebGL limitation the renderer keeps a list of the "non power of two" textures that are then loaded with special settings (see `Textures.elm`). 

## TGA batch conversion 

You can easily create the PNG files from the TGA ones using [ImageMagick][1] `mogrify` command-line utility:

```
find . -iname '*.tga' | while read i; do mogrify -format png "$i"; echo "Created ${i%.*}.png from $i"; done
```

[1]: https://imagemagick.org/index.php