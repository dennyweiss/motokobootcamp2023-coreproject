<template>
  <div class="App px-4 lg:px-8">
    <header class="App-header !h-72">
      <img :src="logo" class="App-logo" alt="logo"/>
      <p class="slogan">Headless DAO</p>
    </header>
    <div class="max-w-screen-sm px-8 mx-auto whitespace-pre-line">
      <p class="block  whitespace-pre-line flex justify-center text-center">
        For interacting with the Headless DAO <br> be a real Developer and use use `DFX` and a DFX based principle<br>and
        a DFX wallet that holds and MB tokens.
      </p>
      <p class="block">
        <strong class="block mt-4 mb-3  text-center">Features:</strong>
      <ul class="px-4 text-center">
        <li>Proposal live cycle [isDraft,isPublished,isArchived]</li>
        <li>Proposal ownership <i>(owner publishes proposals)</i></li>
        <li>Proposal submission requires 1 MB</li>
        <li>Proposal execution happens automatically when the votings accumulated 100.0 voting power</li>
        <li>Executed proposals are automatically archived</li>
        <li>Proposal target webpage is certified</li>
      </ul>
      </p>
      <p class="block">
        <strong class="block mt-4 mb-3 text-center">IC network canisters</strong>
        <pre><code class="language-json">
          {
            "dao": {
              "ic": "usg2o-yyaaa-aaaak-qbu5q-cai"
            },
            "interface": {
              "ic": "uaanx-uiaaa-aaaak-qbu6q-cai"
            },
            "webpage": {
              "ic": "uhbld-zqaaa-aaaak-qbu6a-cai"
            }
          }
        </code></pre>
      </p>
      <p class="block">
        <strong class="block mt-4 mb-3 text-center">dfx.json</strong>
         <pre><code class="language-json">
          {
            "canisters": {
              "webpage": {
                "main": "./src/webpage/main.mo",
                "type": "motoko"
              },
              "dao": {
                "main": "./src/dao/main.mo",
                "type": "motoko"
              },
              "assets": {
                "dependencies": [
                  "webpage",
                  "dao"
                ],
                "frontend": {
                  "entrypoint": "dist/index.html"
                },
                "source": [
                  "dist/"
                ],
                "type": "assets"
              }
            },
            "defaults": {
              "build": {
                "packtool": ""
              }
            },
            "networks": {
              "local": {
                "bind": "127.0.0.1:8000",
                "type": "ephemeral"
              },
              "ic": {
                "providers": [
                  "https://mainnet.dfinity.network"
                ],
                "type": "persistent"
              }
            },
            "version": 1
          }
        </code></pre>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import logo from '@/app/assets/dfinity.svg'
</script>

<style>
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen",
  "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
  sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #424242;
}

button {
  font-weight: 600;
}

.slogan {
  font-size: 1.7em;
  margin-bottom: 0;
}

.twitter {
  font-size: 0.4em;
}

.App-logo {
  height: 14vmin;
  pointer-events: none;
  transform: scale(1);
  animation: pulse 3s infinite;
}

.App-header {
  height: calc(50vh - 70px);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
}

.examples {
  padding: 30px 100px;
  display: grid;
  grid-gap: 30px;
  grid-template-columns: 1fr 1fr 1fr;
}

.examples-title {
  font-size: 1.3em;
  margin-bottom: 0;
  text-align: center;
}

.example {
  padding: 50px 50px;
  min-height: 300px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  /*border: 1px solid black;*/
  /*background: #f4f4f4;*/
  border-radius: 15px;
}

.example-disabled {
  font-size: 1.3em;
  color: #9e9e9e;
}

.demo-button {
  background: #a02480;
  padding: 0 1.3em;
  margin-top: 1em;
  border-radius: 60px;
  font-size: 0.7em;
  height: 35px;
  outline: 0;
  border: 0;
  cursor: pointer;
  color: white;
}

.demo-button:active {
  color: white;
  background: #979799;
}

.auth-section {
  padding: 1em;
  display: flex;
  justify-content: flex-end;
  align-items: center;
  text-align: right;
  position: fixed;
  top: 0;
  right: 0;
}

@keyframes pulse {
  0% {
    transform: scale(0.97);
    opacity: 0;
  }

  70% {
    transform: scale(1);
    opacity: 1;
  }

  100% {
    transform: scale(0.97);
    opacity: 0;
  }
}
</style>
