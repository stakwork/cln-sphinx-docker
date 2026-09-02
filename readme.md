# cln-sphinx

Core Lightning + the Sphinx HTLC interceptor plugin (`gateway-cln-extension`).

This is the image sphinx-swarm runs as the `cln` container. Since 0.4.0 it
is published to **`ghcr.io/stakwork/cln-sphinx`** by GitHub Actions and is
built directly on the official `elementsproject/lightningd` image, pinned by
digest. CLN is not compiled here any more; only the interceptor plugin is.
The old Docker Hub image `sphinxlightning/cln-sphinx`, the
`sphinxlightning/cln` intermediate image, and the `stakwork/lightning` fork
are no longer used.

Background and the full upgrade procedure:
`docs/cln-upgrade.md` in the stakwork/sphinx repo.

## Publish

Everything is driven by GitHub releases (`.github/workflows/publish.yml`):

1. Update `CLN_IMAGE` at the top of the Dockerfile (tag **and** digest from
   https://github.com/ElementsProject/lightning/releases).
2. Push to master.
3. Publish a GitHub **pre-release** with the new version as the tag, e.g. `0.4.0`.
   CI builds amd64 + arm64 and pushes `ghcr.io/stakwork/cln-sphinx:0.4.0`.
4. Run it on a staging swarm (set `version: "0.4.0"` on the cln node in that
   swarm's `vol/<project>/config.yaml` and restart).
5. When it is good, edit the release and untick "pre-release". Republishing
   as a full release pushes the same build as `:latest`, which is what swarm
   hosts pull via `scripts/update.sh cln`.

**First publish only:** GHCR creates the package as private. Swarm hosts
pull anonymously, so after the first workflow run set the package visibility
to public under the org's package settings.

If republishing does not retrigger the workflow, create a new release with
the same tag after deleting the old one, or run the `latest` retag by hand:

```
docker buildx imagetools create -t ghcr.io/stakwork/cln-sphinx:latest ghcr.io/stakwork/cln-sphinx:0.4.0
```

## Local build (optional)

```
docker buildx build --platform linux/amd64 --load -t cln-sphinx .
docker run --rm --platform linux/amd64 --entrypoint lightningd cln-sphinx --version
```

The plugin compile is a large Rust build; on Apple silicon it runs under
emulation and is slow. Prefer CI.

## Components

| Piece | Source | Notes |
|---|---|---|
| lightningd, cln-grpc, all stock plugins | official image | assembled by upstream from signed release tarballs |
| `gateway-cln-extension` | https://github.com/stakwork/fedimint branch `intercept-onion-4` | fedimint's gateway plugin patched to intercept every HTLC and forward the raw onion; the mixer connects on grpc port + 200 |

The Rust toolchain for the plugin is pinned (`RUST_VERSION` build arg)
because the fedimint branch is from April 2024.

## Version history

| cln-sphinx | CLN | base | registry |
|---|---|---|---|
| 0.4.0 | v26.06.7 | `elementsproject/lightningd:v26.06.7` (digest pinned) | ghcr.io/stakwork/cln-sphinx |
| 0.3.7 | v24.11.1 | `sphinxlightning/cln:v24.11.1` (own build of the stakwork/lightning fork) | docker.io/sphinxlightning/cln-sphinx |
