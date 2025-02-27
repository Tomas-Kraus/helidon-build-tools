/*
 * Copyright (c) 2020, 2023 Oracle and/or its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pipeline {
  agent {
    label "linux"
  }
  options {
    parallelsAlwaysFailFast()
  }
  stages {
    stage('release') {
      when {
        branch '**/release-*'
      }
      stages {
        stage('build') {
          environment {
            NPM_CONFIG_REGISTRY = credentials('npm-registry')
            GITHUB_SSH_KEY = credentials('helidonrobot-github-ssh-private-key')
            MAVEN_SETTINGS_FILE = credentials('helidonrobot-maven-settings-ossrh')
            GPG_PUBLIC_KEY = credentials('helidon-gpg-public-key')
            GPG_PRIVATE_KEY = credentials('helidon-gpg-private-key')
            GPG_PASSPHRASE = credentials('helidon-gpg-passphrase')
          }
          steps {
            sh './etc/scripts/release.sh release_build'
            archiveArtifacts artifacts: "ide-support/vscode-extension/target/vscode-helidon.vsix"
          }
        }
        stage('cli-native') {
          parallel {
            stage('cli-linux') {
              steps {
                sh './etc/scripts/build-cli.sh --release'
                archiveArtifacts artifacts: "cli/impl/target/helidon"
              }
            }
            stage('cli-windows') {
              agent {
                label "windows"
              }
              steps {
                bat './etc/scripts/build-cli.bat /release'
                archiveArtifacts artifacts: "cli/impl/target/helidon.exe"
              }
            }
          }
        }
      }
    }
  }
}
