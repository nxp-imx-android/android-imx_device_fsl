/*
 * Copyright (C) 2015 Freescale Semiconductor, Inc.
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
package com.freescale.media;

import android.os.Parcel;
import android.os.Parcelable;
import android.media.MediaPlayer;

public final class FslMediaPlayer extends MediaPlayer{

	private final static String IMEDIA_PLAYER = "android.media.IMediaPlayer";
	private static final int INVOKE_ID_SET_PLAY_SPEED = 8;	

       /**
        * Set play speed.
        *
        * @param Speed is normalized speed multiplied by 0x10000
        * Range of normalized speed is:
        *         [-16,-2] means rewind, [0.1, 16] means forward, step is 0.1
        * When normalized speed is [0.1, 1.9] audio is outputted, otherwise audio
        * is not outputted.
        */
	public void setPlaySpeed(int[] Speed){
		Parcel request = Parcel.obtain();
		Parcel reply = Parcel.obtain();
		try{
			request.writeInterfaceToken(IMEDIA_PLAYER);
			request.writeInt(INVOKE_ID_SET_PLAY_SPEED);
			request.writeInt(Speed[0]);
			invoke(request, reply);
			Speed[0] = reply.readInt();
		}finally{
			request.recycle();
			reply.recycle();
		}
	}
}
