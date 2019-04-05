/*
 * Copyright 2012-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.spring.initializr.generator.spring.configuration;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

import io.spring.initializr.generator.io.template.MustacheTemplateRenderer;
import io.spring.initializr.generator.project.ResolvedProjectDescription;
import io.spring.initializr.generator.project.contributor.ProjectContributor;
import io.spring.initializr.metadata.InitializrMetadata;

public class DeployConfigContributor implements ProjectContributor {

	private final ResolvedProjectDescription projectDescription;

	private final MustacheTemplateRenderer templateRenderer;

	public DeployConfigContributor(ResolvedProjectDescription resolvedProjectDescription,
			MustacheTemplateRenderer templateRenderer,
			InitializrMetadata initializrMetadata) {
		this.projectDescription = resolvedProjectDescription;
		this.templateRenderer = templateRenderer;
	}

	@Override
	public void contribute(Path projectRoot) {

		System.out.println(this.projectDescription.getDeploy());

		if (this.projectDescription.getDeploy() != null) {

			if (this.projectDescription.getDeploy().contains("puppet")) {
				System.out.println("Inside puppet if ");
				addPuppet(projectRoot);
			}

			if (this.projectDescription.getDeploy().contains("docker")) {
				System.out.println("Inside docker if ");
				addDocker(projectRoot);
			}

		}

	}

	public void addPuppet(Path projectRoot) {

		Map<String, String[]> puppetModulesFiles = new HashMap<>();

		String[] manifests = { "config.pp", "deploy.pp", "init.pp", "install.pp",
				"params.pp", "service.pp" };
		String[] templates = { "application.yaml.erb",
				projectDescription.getArtifactId() + ".conf.erb" };

		puppetModulesFiles.put(
				"puppet_modules/" + projectDescription.getName() + "/manifests/",
				manifests);

		/*
		 * puppetModulesFiles.put( "puppet_modules/" + projectDescription.getName() +
		 * "/templates/", templates);
		 */

		/*
		 * createFile( "puppet_hiera/nodes/ondemand/" + projectDescription.getName() +
		 * ".yaml", projectDescription.getName() + ".yaml", "puppet", projectRoot);
		 */

		for (Map.Entry<String, String[]> entry : puppetModulesFiles.entrySet()) {
			for (String file : entry.getValue()) {
				try {
					createFile(entry.getKey() + file, file, "puppet", projectRoot);
				}
				catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	public void addDocker(Path projectRoot) {

		Map<String, String[]> dockerFiles = new HashMap<>();

		String[] globalDockerFiles = { "build-images", "run-advice", "run-local",
				"stack.yml" };
		String[] appDockerFiles = { "Dockerfile", "entrypoint.sh" };

		dockerFiles.put("docker/", globalDockerFiles);
		dockerFiles.put("docker/" + projectDescription.getArtifactId() + "/",
				appDockerFiles);

		for (Map.Entry<String, String[]> entry : dockerFiles.entrySet()) {
			for (String file : entry.getValue()) {
				try {
					createFile(entry.getKey() + file, file, "docker", projectRoot);
				}
				catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		try {

			Files.createDirectories(
					projectRoot.resolve("docker/" + projectDescription.getArtifactId()
							+ "/" + projectDescription.getPackaging()));
			Files.createDirectories(projectRoot.resolve(
					"docker/" + projectDescription.getArtifactId() + "/puppet_hiera"));
			Files.createDirectories(projectRoot.resolve(
					"docker/" + projectDescription.getArtifactId() + "/puppet_modules"));
		}
		catch (IOException e) {
			e.printStackTrace();
		}

	}

	public void createFile(String filepath, String filename, String deployType,
			Path projectRoot) throws IOException {

		Map<String, Object> model = new HashMap<>();
		model.put("puppetModuleName", projectDescription.getName().replace('-', '_'));
		model.put("artifactId", projectDescription.getArtifactId());
		model.put("appName", projectDescription.getName());
		model.put("groupId", projectDescription.getGroupId());
		model.put("packaging", projectDescription.getPackaging());

		Path output = projectRoot.resolve(filepath);
		if (!Files.exists(output.getParent())) {
			Files.createDirectories(output.getParent());
		}

		Path file = Files.createFile(output);

		PrintWriter writer = new PrintWriter(Files.newBufferedWriter(file));

		writer.write(this.templateRenderer.render(deployType + "/" + filename, model));
		writer.close();

	}

}
