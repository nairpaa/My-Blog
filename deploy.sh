#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building production...${NC}"
cd /opt/Blogs/blog-new
JEKYLL_ENV=production bundle exec jekyll build

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed!${NC}"
    exit 1
fi

echo -e "${YELLOW}Copying to production repo...${NC}"
rsync -av --delete --exclude '.git' --exclude 'CNAME' _site/ /opt/Blogs/blog-prod/

echo -e "${YELLOW}Deploying to GitHub...${NC}"
cd /opt/Blogs/blog-prod
git add .
git commit -m "Deploy $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Deployed successfully!${NC}"
else
    echo -e "${RED}Deploy failed!${NC}"
    exit 1
fi