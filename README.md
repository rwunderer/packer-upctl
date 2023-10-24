[![GitHub license](https://img.shields.io/github/license/rwunderer/packer-upctl.svg)](https://github.com/rwunderer/packer-upctl/blob/main/LICENSE)
<a href="https://renovatebot.com"><img alt="Renovate enabled" src="https://img.shields.io/badge/renovate-enabled-brightgreen.svg?style=flat-square"></a>

# packer-upctl
Enhanced packer image with upctl as needed when creating images on UpCloud

Creating template images with packer on [UpCloud](https://upcloud.com) needs `upctl` to 
actually stop the server after image creation.

This repo just enhances the standard packer image with upctl.

## Workflows

| Badge      | Description
|------------|---------
|[![Auto-Tag](https://github.com/rwunderer/packer-upctl/actions/workflows/renovate-create-tag.yml/badge.svg)](https://github.com/rwunderer/packer-upctl/actions/workflows/renovate-create-tag.yml) | Automatic Tagging of new packer releases
|[![Docker](https://github.com/rwunderer/packer-upctl/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/rwunderer/packer-upctl/actions/workflows/docker-publish.yml) | Docker image build
