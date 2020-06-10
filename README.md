# audiveris-docker
This docker container simplifies the recognition of mass image files of musical scores using the open-source software Audiveris.

# Usage
- Place all images of sheet music in the `to_do` directory
- `docker-compose up`
- Audiveris will output all the data into the `finished` directory


Try to build with latest tesseract from source
https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=tesseract-ocr-git