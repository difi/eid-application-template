/*
 * Copyright 2012-2019 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.spring.initializr.generator.buildsystem.gradle;

import io.spring.initializr.generator.buildsystem.DependencyScope;

/**
 * A {@link GradleBuildWriter} suitable for Gradle 3.
 *
 * @author Stephane Nicoll
 */
public class Gradle3BuildWriter extends GradleBuildWriter {

	protected String configurationForScope(DependencyScope type) {
		switch (type) {
		case ANNOTATION_PROCESSOR:
			return "compileOnly";
		case COMPILE:
			return "compile";
		case COMPILE_ONLY:
			return "compileOnly";
		case PROVIDED_RUNTIME:
			return "providedRuntime";
		case RUNTIME:
			return "runtime";
		case TEST_COMPILE:
			return "testCompile";
		case TEST_RUNTIME:
			return "testRuntime";
		default:
			throw new IllegalStateException(
					"Unrecognized dependency type '" + type + "'");
		}
	}

}
